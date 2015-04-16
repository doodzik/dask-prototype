var React = require("react");
var R     = require('ramda');
import { needsAuth } from './auth.jsx';
import { AuthStore, UserStore } from './store.js';

export var TaskIndex = React.createClass(R.merge(needsAuth, {
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

export var TaskCreate = React.createClass(R.merge(needsAuth, {
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
