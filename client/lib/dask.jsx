var Promise = require("bluebird");
var moment  = require('moment');
require('moment-recur');
var React   = require("react");
var R       = require('ramda');
import { needsAuth } from './auth.jsx';
import { AuthStore, TaskStore, DaskStore } from './store.js';

var Router       = require("react-router"),
    Link         = Router.Link;

var filterWeekDay = function(tasks) {
      return R.filter((task) => {
        return R.contains(moment().weekday())(task.days)
      }, tasks)
}

var taskIsInterval = function(task) {
  let myDate = moment(task.startDate)
  let type = ['day', 'week', 'month'][task.intervalType]
  let interval = myDate.recur().every(task.interval, type);
  return interval.matches(moment())
}

var taskIsToday = function(task) {
  return R.contains(moment().weekday())(task.days)
}

var taskIsTime = function(task) {
  let mom = moment();
  let h = mom.hour();
  let m = mom.minute();
  if(task.startHour < h && task.endHour > h) {
    return true
  } else if((task.startHour == h || task.endHour == h ) && task.startMinute <= m && task.endMinute >= m) {
    return true
  } else {
    return false
  }
}

var taskDiffTime = function(a, b) { 
var diff = a.startHour - b.startHour; 
if(diff == 0){
  diff = a.startMinute - b.startMinute; 
}
return diff
};

var sortTasksTime = function(tasks) {
  return R.sort(taskDiffTime, tasks);
}

var isChecked = function(checked) {
  return moment(moment(checked).format("YYYY-MM-DD")).isBefore(moment().format("YYYY-MM-DD"));
}

var isCheckedTask = function(task) {
  return moment(moment(task.checked).format("YYYY-MM-DD")).isBefore(moment().format("YYYY-MM-DD"));
}

var filterChecked = function(tasks) {
    return R.filter((task) => { return isChecked(task.checked); }, tasks)
}

export var DaskIndex = React.createClass(R.merge(needsAuth, {
  getInitialState: function() {
    return {tasks: []};
  },
  componentDidMount: function(){
    TaskStore.all()
    .filter(taskIsToday)
    .filter(taskIsInterval)
    .filter(taskIsTime)
    .filter(isCheckedTask)
    .then(sortTasksTime)
    .then(tasks => this.setState({tasks: tasks}))
  },

  check: function(task, index, e){
    e.preventDefault();
    var newData = this.state.tasks.slice(); //copy array
    newData.splice(index, 1); //remove element
    DaskStore.check(task);
    this.setState({tasks: newData}); //update state
  },

  render: function() {
    return (
      <div>
        <h2>Dasks</h2>
        <ul className="dask-nav">
          <li><Link to='task/create'>Create Task</Link></li>
        </ul>
        <ul>
          { this.state.tasks.length == 0 ? <li>no more tasks</li> : this.state.tasks.map((task, i) => { return <li key={i}><input type="checkbox" onChange={R.curry(this.check)(task, i)}/><Link to='task/:id/edit' params={task} >{task.name}</Link></li> })}
        </ul>
      </div>
    );
  }
}));

var DaskCheckbox = React.createClass({
  getInitialState: function(){
    return { isChecked: !isCheckedTask(this.props.task) };
  },
  check: function(e){
    (e.target.checked) ? DaskStore.check(this.props.task) : DaskStore.uncheck(this.props.task);
    this.setState({ isChecked: e.target.checked })
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
    TaskStore.all()
    .filter(taskIsToday)
    .filter(taskIsInterval)
    .filter(taskIsTime)
    .then(sortTasksTime)
    .then(tasks => this.setState({tasks: tasks}));
  },

  render: function() {
    return (
      <div>
        <h2>All Dasks</h2>
        <ul className="dask-nav">
          <li><Link to='task/create'>Create Task</Link></li>
        </ul>
        <ul>
          { this.state.tasks.length == 0 ? <li>no more tasks</li> : this.state.tasks.map((task, i) => { return <li key={i}><DaskCheckbox task={task}></DaskCheckbox></li> })}
        </ul>
      </div>
    );
  }
}));
