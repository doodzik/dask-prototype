var React = require("react");
var R     = require('ramda');
var Router       = require("react-router"),
    Link         = Router.Link;
import { needsAuth } from './auth.jsx';
import { AuthStore, UserStore } from './store.js';

export var TaskIndex = React.createClass(R.merge(needsAuth, {
  getInitialState: function() {
    return {tasks: [{id: 'fd', name: 'fds'}]};
  },
  destroy: function(task, index, e){
    var newData = this.state.tasks.slice(); //copy array
    newData.splice(index, 1); //remove element
    this.setState({tasks: newData}); //update state
    //TODO: call server
  },
  render: function() {
    return (
      <div>
        <h2>Tasks</h2>
        <ul>
          { this.state.tasks.length == 0 ? <li>no tasks</li> : this.state.tasks.map((task, i) => { return <li key={i}><Link to='task/:id/edit' params={task} >{task.name}</Link><span className="right" onClick={R.curry(this.destroy)(task, i)}>delete</span></li> })}
        </ul>
      </div>
    );
  }
}));

export var TaskCreate = React.createClass(R.merge(needsAuth, {
    getInitialState: function() {
      return {error: {email: '', password: ''}};
    },
  render: function() {
    return (
      <div>
        <h2>Create Task</h2>
      </div>
    );
  }
}));

export var TaskEdit = React.createClass(R.merge(needsAuth, {
    getInitialState: function() {
      return {error: {email: '', password: ''}};
    },
  render: function() {
    return (
      <div>
        <h2>Dasks</h2>
      </div>
    );
  }
}));
