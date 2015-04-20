var Promise   = require("bluebird");
var React        = require("react");
var R            = require('ramda');
var Router       = require("react-router"),
    Link         = Router.Link;
import { needsAuth } from './auth.jsx';
import { AuthStore, UserStore, TaskStore } from './store.js';

export var TaskIndex = React.createClass(R.merge(needsAuth, {
  getInitialState: function() {
    return {tasks: []};
  },
  componentDidMount: function(){
    let allTasks = Promise.promisify(TaskStore.all);
    allTasks().then((tasks) => {
      this.setState({tasks: tasks});
    });
  },
  destroy: function(task, index, e){
    var newData = this.state.tasks.slice(); //copy array
    newData.splice(index, 1); //remove element
    this.setState({tasks: newData}); //update state
    TaskStore.destroy(task.id);
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

// Days name
export var TaskCreate = React.createClass(R.merge(needsAuth, {
  getInitialState: function() {
    return {error: '', sun: true, mon: true, tue: true, wed: true, thu: true, fri: true, sam: true };
  },
  create: function(e){
    e.preventDefault();
    let name = this.refs.name.getDOMNode().value;
    let days = [ this.state.sun, this.state.mon, this.state.tue, this.state.wed, this.state.thu, this.state.fri, this.state.sam];   
    let convertDays =  days.map((day, i) => { return((day) ? i : day) });
    let selectedDays = R.reject((x) => { return x === false }, convertDays);
    
    let errorMsg = TaskStore.validate(name, selectedDays);
    if(errorMsg.length > 0 ){
      this.setState({error: errorMsg});
    } else {
      TaskStore.create(name, selectedDays)
      window.location.assign('/');
    }
    
  },
  check: function(day, e){
    let checked = this.refs[day].getDOMNode().checked;
    let obj = {};
    obj[day] = checked;
    this.setState(obj);
  },
  render: function() {
    return (
      <div>
        <h2>Create Task</h2>
        <form>
          <label htmlFor="TaskInput">Task Name:</label>
          <input className="u-full-width" ref="name" type="text" />
          { /* (this.state.error.email) ? <div className="error">{this.state.error.email}</div> : null */ }

          <label htmlFor="TaskFilterInput">Filter</label>

          <label htmlFor="TaskFilterDaysInput">Days:</label>

          { /* TODO make checked as default */ }
          <ul className="days-selector">
            <li>
              <label htmlFor="days">Sun</label>
              <input ref="sun" type="checkbox" value="0" checked={this.state.sun} onChange={R.curry(this.check)('sun')}/>
            </li>
            <li>
              <label htmlFor="days">Mon</label>
              <input ref="mon" type="checkbox" value="1" checked={this.state.mon} onChange={R.curry(this.check)('mon')}/>
            </li>
            <li>
              <label htmlFor="days">Tue</label>
              <input ref="tue" type="checkbox" value="2" checked={this.state.tue} onChange={R.curry(this.check)('tue')}/>
            </li>
            <li>
              <label htmlFor="days">Wed</label>
              <input ref="wed" type="checkbox" value="3" checked={this.state.wed} onChange={R.curry(this.check)('wed')}/>
            </li>
            <li>
              <label htmlFor="days">Thu</label>
              <input ref="thu" type="checkbox" value="4" checked={this.state.thu} onChange={R.curry(this.check)('thu')}/>
            </li>
            <li>
              <label htmlFor="days">Fri</label>
              <input ref="fri" type="checkbox" value="5" checked={this.state.fri} onChange={R.curry(this.check)('fri')}/>
            </li>
            <li>
              <label htmlFor="days">Sam</label>
              <input ref="sam" type="checkbox" value="6" checked={this.state.sam} onChange={R.curry(this.check)('sam')}/>
            </li>
          </ul>

          <input className="button-primary" type="submit" value="create" onClick={this.create}/>
        </form>
      </div>
    );
  }
}));

// Days name
export var TaskEdit = React.createClass(R.merge(needsAuth, {
  getInitialState: function() {
    return {error: '', name: '', sun: false, mon: false, tue: false, wed: false, thu: false, fri: false, sam: false };
  },

  componentDidMount: function(){
    let getTasks = Promise.promisify(TaskStore.get);
    let id = this.props.params.id ;
    getTasks(id).then((task) => {
      return [ task.days.map((day) => {
       switch(day) {
          case 0: return { sun: true };
          case 1: return { mon: true };
          case 2: return { tue: true };
          case 3: return { wed: true };
          case 4: return { tue: true };
          case 5: return { fri: true };
          case 6: return { sam: true };
          default: return {};
        }       
      }), task.name ]; 
    }).spread((selectedDays, taskName) => {
      return R.reduce(R.merge, {name: taskName}, selectedDays);
    }).then((obj) => {
      this.setState(obj);
    });
  },

  create: function(e){
    e.preventDefault();
    let id = this.props.params.id ;
    let name = this.refs.name.getDOMNode().value;
    let days = [ this.state.sun, this.state.mon, this.state.tue, this.state.wed, this.state.thu, this.state.fri, this.state.sam];   
    let convertDays =  days.map((day, i) => { return((day) ? i : day) });
    let selectedDays = R.reject((x) => { return x === false }, convertDays);
    
    let errorMsg = TaskStore.validate(name, selectedDays);
    if(errorMsg.length > 0 ){
      this.setState({error: errorMsg});
    } else {
      TaskStore.put(id, name, selectedDays)
      window.location.assign('/');
    }
    
  },
  check: function(day, e){
    let checked = this.refs[day].getDOMNode().checked;
    let obj = {};
    obj[day] = checked;
    this.setState(obj);
  },
  setName: function(e){
    this.setState({name: this.refs.name.getDOMNode().value});
  },
  render: function() {
    return (
      <div>
        <h2>Edit Task</h2>
        <form>
          <label htmlFor="TaskInput">Task Name:</label>
          <input className="u-full-width" ref="name" type="text" value={this.state.name} onChange={this.setName} />
          { /* (this.state.error.email) ? <div className="error">{this.state.error.email}</div> : null */ }

          <label htmlFor="TaskFilterInput">Filter</label>

          <label htmlFor="TaskFilterDaysInput">Days:</label>

          { /* TODO make checked as default */ }
          <ul className="days-selector">
            <li>
              <label htmlFor="days">Sun</label>
              <input ref="sun" type="checkbox" value="0" checked={this.state.sun} onChange={R.curry(this.check)('sun')}/>
            </li>
            <li>
              <label htmlFor="days">Mon</label>
              <input ref="mon" type="checkbox" value="1" checked={this.state.mon} onChange={R.curry(this.check)('mon')}/>
            </li>
            <li>
              <label htmlFor="days">Tue</label>
              <input ref="tue" type="checkbox" value="2" checked={this.state.tue} onChange={R.curry(this.check)('tue')}/>
            </li>
            <li>
              <label htmlFor="days">Wed</label>
              <input ref="wed" type="checkbox" value="3" checked={this.state.wed} onChange={R.curry(this.check)('wed')}/>
            </li>
            <li>
              <label htmlFor="days">Thu</label>
              <input ref="thu" type="checkbox" value="4" checked={this.state.thu} onChange={R.curry(this.check)('thu')}/>
            </li>
            <li>
              <label htmlFor="days">Fri</label>
              <input ref="fri" type="checkbox" value="5" checked={this.state.fri} onChange={R.curry(this.check)('fri')}/>
            </li>
            <li>
              <label htmlFor="days">Sam</label>
              <input ref="sam" type="checkbox" value="6" checked={this.state.sam} onChange={R.curry(this.check)('sam')}/>
            </li>
          </ul>

          <input className="button-primary" type="submit" value="edit" onClick={this.create}/>
        </form>
      </div>
    );
  }
}));
