var Promise = require("bluebird");
var moment  = require('moment');
var React   = require("react");
var R       = require('ramda');
import { needsAuth } from './auth.jsx';
import { AuthStore, TaskStore, DaskStore } from './store.js';

var Router       = require("react-router"),
    Link         = Router.Link;

export var DaskIndex = React.createClass(R.merge(needsAuth, {
  getInitialState: function() {
    // return {tasks: [{id: 'fd', name: 'fds'}]};
    return {tasks: []};
  },
  componentDidMount: function(){
    let allTasks = Promise.promisify(TaskStore.all);
    allTasks().then((tasks) => {
      return R.filter((task) => {
        return R.contains(moment().weekday())(task.days)
      }, tasks)
    }).then((tasks) => {
      return R.filter((task) => {
        return moment(moment(task.checked).format("YYYY-MM-DD")).isBefore(moment().format("YYYY-MM-DD"))
      }, tasks);
    }).then((tasks) => {
      this.setState({tasks: tasks});
    })
  },
  check: function(task, index, e){
    var newData = this.state.tasks.slice(); //copy array
    newData.splice(index, 1); //remove element
    DaskStore.check(task.id);
    this.setState({tasks: newData}); //update state
  },
  render: function() {
    return (
      <div>
        <h2>Dasks</h2>
        <ul className="dask-nav">
          <li><Link to='task/create'>Create Task</Link></li>
          <li><Link to='tasks'>Tasks</Link></li>
          <li><Link to='dasks/all'>All Dasks</Link></li>
        </ul>
        <ul>
          { this.state.tasks.length == 0 ? <li>no more tasks</li> : this.state.tasks.map((task, i) => { return <li key={i}><input type="checkbox" onClick={R.curry(this.check)(task, i)}/><Link to='task/:id/edit' params={task} >{task.name}</Link></li> })}
        </ul>
      </div>
    );
  }
}));

var DaskCheckbox = React.createClass({
  getInitialState: function(){
    let isChecked;
    if(moment(moment(this.props.task.checked).format("YYYY-MM-DD")).isBefore(moment().format("YYYY-MM-DD"))){
      isChecked = false;
    }else{
      isChecked = true;
    }
    return { isChecked: isChecked };
  },
  check: function(e){
    let checked = e.target.checked;
    if(checked){
      DaskStore.check(this.props.task.id)
    }else{
      DaskStore.uncheck(this.props.task.id)
    }
    this.setState({ isChecked: checked })

  },
  render: function() {
return(<div><input type="checkbox" onChange={this.check} checked={this.state.isChecked}/><Link to='task/:id/edit' params={this.props.task} >{this.props.task.name}</Link></div>)
  }
});

export var DaskAll = React.createClass(R.merge(needsAuth, {
  getInitialState: function() {
    return {tasks: []};
  },

  componentDidMount: function(){
    let allTasks = Promise.promisify(TaskStore.all);
    allTasks().then((tasks) => {
      return R.filter((task) => {
        return R.contains(moment().weekday())(task.days)
      }, tasks)
    }).then((tasks) => {
      this.setState({tasks: tasks});
    });
  },

  render: function() {
    return (
      <div>
        <h2>All Dasks</h2>
        <ul className="dask-nav">
          <li><Link to='dasks'>Dasks</Link></li>
          <li><Link to='task/create'>Create Task</Link></li>
          <li><Link to='tasks'>Tasks</Link></li>
        </ul>
        <ul>
          { this.state.tasks.length == 0 ? <li>no more tasks</li> : this.state.tasks.map((task, i) => { return <li key={i}><DaskCheckbox task={task}></DaskCheckbox></li> })}
        </ul>
      </div>
    );
  }
}));
