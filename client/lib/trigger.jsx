var Promise    = require("bluebird");
var React      = require("react");
var R          = require('ramda');
var DatePicker = require('react-datepicker');
var moment     = require('moment');
var Router     = require("react-router"),
    Link       = Router.Link;
import { needsAuth } from './auth.jsx';
import { AuthStore, UserStore, TaskStore, TriggerStore } from './store.js';

export var TriggerIndex = React.createClass(R.merge(needsAuth, {
  getInitialState: function() {
    return {triggers: []};
  },
  componentDidMount: function(){
    TriggerStore.all()
    .then(triggers => this.setState({triggers: triggers}));
  },
  create: function() {
    let name = this.refs.triggerName.getDOMNode().value
    TriggerStore.create(name).then(trigger => {
      // .then(tasks => this.setState({triggers: tasks}));
      this.refs.triggerName.getDOMNode().value = ''
      TriggerStore.all()
      .then(triggers => this.setState({triggers: triggers}));
    })
  },
  destroy: function(task, index, e){
    TriggerStore.destroy(task)
    .then(t => {
      TriggerStore.all()
      .then(triggers => this.setState({triggers: triggers}));
    })
  },
  render: function() {
    return (
      <div>
        <h2>Triggers</h2>
        <form>
          <input className="u-full-width" placeholder="trigger name" ref="triggerName" />
          <input className="button-primary" type="button" value="create" onClick={this.create} />
        </form>
        <ul>
          { this.state.triggers.length == 0 ? <li>no triggers</li> : this.state.triggers.map((trigger, i) => { return <li key={i}><Link to='triggers/:id' params={trigger} >{trigger.name}</Link><span className="right" onClick={R.curry(this.destroy)(trigger.id, i)}>delete</span></li> })}
        </ul>
      </div>
    );
  }
}));

// Days name
export var TriggerShow = React.createClass(R.merge(needsAuth, {
  mixins: [ Router.State ],

  getInitialState: function() {
    return { triggers: [], name: '' };
  },

  componentDidMount: function(){
    let name = this.getParams().id
    TriggerStore.get(name)
    .then(triggers => {
      this.setState({triggers: triggers.tasks, name: triggers.name})
    })
  },

  trigger: function(e){
    e.preventDefault();
    let id = this.getParams().id
    
    TriggerStore.trigger(id).then(t => {
      window.location.assign('/');
    })
  },
  create: function(e){
    e.preventDefault();
    let name = this.refs.triggerName.getDOMNode().value
    let trigger = this.getParams().id
    TriggerStore.createTask(trigger, name)
    TriggerStore.get(trigger)
    .then(triggers => {
      this.setState({triggers: triggers.tasks })
    })
  },
  destroy: function(name, i, e){
    let trigger = this.getParams().id
    TriggerStore.destroyTask(trigger, name)
    .then(t => {
      TriggerStore.get(trigger)
      .then(triggers => {
        this.setState({triggers: triggers.tasks })
      })
    })
  },
  render: function() {
    let name = this.state.name
    return (
      <div>
        <h2>Trigger: {name}</h2>
        <form>
          <input className="u-full-width" placeholder="trigger task" ref="triggerName" />
          <input className="button-primary" type="button" value="create" onClick={this.create} />
          <input className="button-primary button-clone" type="button" value="trigger" onClick={this.trigger} />
        </form>
          { this.state.triggers.length == 0 ? <li>no triggers</li> : this.state.triggers.map((trigger, i) => { return <li key={i}>{trigger}<span className="right" onClick={R.curry(this.destroy)(trigger, i)}>delete</span></li> })}
      </div>
    );
  }
}));
