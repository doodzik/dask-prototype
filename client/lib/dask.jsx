var React = require("react");
var R     = require('ramda');
import { needsAuth } from './auth.jsx';
import { AuthStore } from './store.js';

var Router       = require("react-router"),
    Link         = Router.Link;

export var DaskIndex = React.createClass(R.merge(needsAuth, {
  getInitialState: function() {
    return {tasks: [{id: 'fd', name: 'fds'}]};
  },
  check: function(task, index, e){
    var newData = this.state.tasks.slice(); //copy array
    newData.splice(index, 1); //remove element
    this.setState({tasks: newData}); //update state
    //TODO: call server
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

export var DaskAll = React.createClass(R.merge(needsAuth, {
  getInitialState: function() {
    return {tasks: [{id: 'fd', name: 'fds'}]};
  },
  check: function(task, index, e){
    let checked = e.target.checked;
    if(checked){
      //TODO: call server
    }else{
      //TODO: call server
    }
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
          { this.state.tasks.length == 0 ? <li>no more tasks</li> : this.state.tasks.map((task, i) => { return <li key={i}><input type="checkbox" onClick={R.curry(this.check)(task, i)}/><Link to='task/:id/edit' params={task} >{task.name}</Link></li> })}
        </ul>
      </div>
    );
  }
}));
