var Promise    = require("bluebird");
var React      = require("react");
var R          = require('ramda');
var DatePicker = require('react-datepicker');
var moment     = require('moment');
var Router     = require("react-router"),
    Link       = Router.Link;
import { needsAuth } from './auth.jsx';
import { AuthStore, UserStore, TaskStore } from './store.js';

var taskDiffName = function(a, b) { 
  let diff = a.name.localeCompare(b.name) 
  return diff
};

var sortTasksName = function(tasks) {
  return R.sort(taskDiffName, tasks);
}


export var TaskIndex = React.createClass(R.merge(needsAuth, {
  getInitialState: function() {
    return {tasks: []};
  },
  componentDidMount: function(){
    TaskStore.all()
    .then(sortTasksName)
    .then(tasks => this.setState({tasks: tasks}));
  },
  fuzzySearch: function() {
    let search = this.refs.fuzzySearch.getDOMNode().value
    TaskStore.all()
    .then(sortTasksName)
    .filter(task => {
      if(task.name.indexOf(search) >= 0) {
        return true
      } else {
        return false
      }
    })
    .then(tasks => this.setState({tasks: tasks}));
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
        <input placeholder="search" onChange={this.fuzzySearch} ref="fuzzySearch" />
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
    return {error: '', startDate: moment(), interval: 1, startMinute: 0, startHour: 0, endMinute: 59, endHour: 23, sun: true, mon: true, tue: true, wed: true, thu: true, fri: true, sam: true };
  },

  handleStartDateChange: function(date) {
    this.setState({ startDate: date });
  },
  handleInterval: function(e){
    let interval = this.refs.interval.getDOMNode().value;
    this.setState({ interval: (parseInt(interval, 10)|| 0) });
  },
  handleStartHour: function(){
    let startHour = this.refs.startHour.getDOMNode().value;
    this.setState({ startHour: (parseInt(startHour, 10)|| 0) });
  },
  handleStartMinute: function(){
    let startMinute = this.refs.startMinute.getDOMNode().value;
    this.setState({ startMinute: (parseInt(startMinute, 10) || 0) });
  },
  handleEndHour: function(){
    let endHour = this.refs.endHour.getDOMNode().value;
    this.setState({ endHour: (parseInt(endHour, 10)|| 0) });
  },
  handleEndMinute: function(){
    let endMinute = this.refs.endMinute.getDOMNode().value;
    this.setState({ endMinute: (parseInt(endMinute, 10)|| 0) });
  },

  create: function(e){
    e.preventDefault();
    let name = this.refs.name.getDOMNode().value;
    let days = [ this.state.sun, this.state.mon, this.state.tue, this.state.wed, this.state.thu, this.state.fri, this.state.sam];   
    let convertDays =  days.map((day, i) => { return((day) ? i : day) });
    let selectedDays = R.reject((x) => { return x === false }, convertDays);

    let startHour   = parseInt(this.state.startHour, 10);
    let startMinute = parseInt(this.state.startMinute, 10);
    let endHour     = parseInt(this.state.endHour, 10);
    let endMinute   = parseInt(this.state.endMinute, 10);
    let interval     = parseInt(this.state.interval, 10);
    let intervalType = parseInt(this.refs.intervalType.getDOMNode().value, 10);
    
    var err = TaskStore.validateInterval(startHour, startMinute, endHour, endMinute, interval)
    let errorMsg = TaskStore.validate(name, selectedDays);
    err['name'] = errorMsg;
    console.log(err)
    if(err.name.length > 0 || err.startHour.length > 0 || err.startMinute.length > 0 || err.endHour.length > 0 || err.endMinute.length > 0 || err.interval.length > 0) {
        this.setState({error: err})
    } else {
      TaskStore.create(name, selectedDays, startHour, startMinute, endHour, endMinute, interval,intervalType, this.state.startDate);
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
          { (this.state.error.name && this.state.error.name.length > 0) ? <div className="error">{this.state.error.name }</div> : null }

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

          <label>Time</label>
          <div>
            <div>Start
              <input type="text" value={this.state.startHour} ref="startHour" onChange={this.handleStartHour}/> Hour <input type="text" value={this.state.startMinute} ref="startMinute" onChange={this.handleStartMinute}/> Minutes
            { (this.state.error.startHour && this.state.error.startHour.length > 0) ? <div className="error">{this.state.error.startHour}</div> : null }
            { (this.state.error.startMinute && this.state.error.startMinute.length > 0) ? <div className="error">{this.state.error.startMinute}</div> : null }
            </div>
            <div>End
              <input type="text" value={this.state.endHour} ref="endHour" onChange={this.handleEndHour}/> Hour <input type="text" value={this.state.endMinute} ref="endMinute" onChange={this.handleEndMinute}/> Minutes
            { (this.state.error.endHour && this.state.error.endHour.length > 0) ? <div className="error">{this.state.error.endHour}</div> : null }
            { (this.state.error.endMinute && this.state.error.endMinute.length > 0) ? <div className="error">{this.state.error.endMinute}</div> : null }
            </div>
          </div>

          <label htmlFor="TaskFilterIntervallInput">Intervall:</label>
          <label htmlFor="TaskFilterIntervallInput">start date</label>
          <DatePicker
            key="example1"
            selected={this.state.startDate}
            onChange={this.handleStartDateChange}
          />

          <div>     
            <span htmlFor="TaskFilterIntervallInput">every</span>
            <input type="text" value={this.state.interval} ref="interval" onChange={this.handleInterval}/>
            { (this.state.error.interval && this.state.error.interval.length > 0) ? <div className="error">{this.state.error.interval}</div> : null }
            <select ref="intervalType">
              <option value="0">Day</option>
              <option value="1">Week</option>
              <option value="2">Month</option>
            </select>
          </div>

          <input className="button-primary" type="submit" value="create" onClick={this.create}/>
        </form>
      </div>
    );
  }
}));

// Days name
export var TaskEdit = React.createClass(R.merge(needsAuth, {
  getInitialState: function() {
    return {error: {}, name: '', sun: false, mon: false, tue: false, wed: false, thu: false, fri: false, sam: false, startDate: moment(), interval: 1, intervalType: 0, startMinute: 0, startHour: 0, endMinute: 59, endHour: 23 };
  },

  handleStartDateChange: function(date) {
    this.setState({ startDate: date });
  },
  handleInterval: function(e){
    let interval = this.refs.interval.getDOMNode().value;
    this.setState({ interval: (parseInt(interval, 10)|| 0) });
  },
  handleStartHour: function(){
    let startHour = this.refs.startHour.getDOMNode().value;
    this.setState({ startHour: (parseInt(startHour, 10)|| 0) });
  },
  handleStartMinute: function(){
    let startMinute = this.refs.startMinute.getDOMNode().value;
    this.setState({ startMinute: (parseInt(startMinute, 10) || 0) });
  },
  handleEndHour: function(){
    let endHour = this.refs.endHour.getDOMNode().value;
    this.setState({ endHour: (parseInt(endHour, 10)|| 0) });
  },
  handleEndMinute: function(){
    let endMinute = this.refs.endMinute.getDOMNode().value;
    this.setState({ endMinute: (parseInt(endMinute, 10)|| 0) });
  },

  componentDidMount: function(){
    let id = this.props.params.id;
    TaskStore.get(id).then((task) => {
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
      }), task ]; 
    }).spread((selectedDays, task) => {
      task['startDate'] = moment(task.startDate);
      return R.reduce(R.merge, task, selectedDays);
    }).then(obj => this.setState(obj));
  },

  create: function(e){
    e.preventDefault();
    let id = this.props.params.id ;
    let name = this.refs.name.getDOMNode().value;
    let days = [ this.state.sun, this.state.mon, this.state.tue, this.state.wed, this.state.thu, this.state.fri, this.state.sam];   
    let convertDays =  days.map((day, i) => { return((day) ? i : day) });
    let selectedDays = R.reject((x) => { return x === false }, convertDays);
    
    let startHour   = parseInt(this.state.startHour, 10);
    let startMinute = parseInt(this.state.startMinute, 10);
    let endHour     = parseInt(this.state.endHour, 10);
    let endMinute   = parseInt(this.state.endMinute, 10);
    let interval     = parseInt(this.state.interval, 10);
    let intervalType = parseInt(this.state.intervalType, 10);
    
    var err = TaskStore.validateInterval(startHour, startMinute, endHour, endMinute, interval)
    let errorMsg = TaskStore.validate(name, selectedDays);
    err['name'] = errorMsg;
    if(err.name.length > 0 || err.startHour.length > 0 || err.startMinute.length > 0 || err.endHour.length > 0 || err.endMinute.length > 0 || err.interval.length > 0) {
        this.setState({error: err});
    } else {
      TaskStore.put(id, name, selectedDays, startHour, startMinute, endHour, endMinute, interval, intervalType, this.state.startDate);
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
  duplicate: function(e) {
    e.preventDefault();
    let name = this.refs.name.getDOMNode().value;
    let days = [ this.state.sun, this.state.mon, this.state.tue, this.state.wed, this.state.thu, this.state.fri, this.state.sam];   
    let convertDays =  days.map((day, i) => { return((day) ? i : day) });
    let selectedDays = R.reject((x) => { return x === false }, convertDays);
    
    let startHour   = parseInt(this.state.startHour, 10);
    let startMinute = parseInt(this.state.startMinute, 10);
    let endHour     = parseInt(this.state.endHour, 10);
    let endMinute   = parseInt(this.state.endMinute, 10);
    let interval     = parseInt(this.state.interval, 10);
    let intervalType = parseInt(this.state.intervalType, 10);
    
    var err = TaskStore.validateInterval(startHour, startMinute, endHour, endMinute, interval)
    let errorMsg = TaskStore.validate(name, selectedDays);
    err['name'] = errorMsg;
    if(err.name.length > 0 || err.startHour.length > 0 || err.startMinute.length > 0 || err.endHour.length > 0 || err.endMinute.length > 0 || err.interval.length > 0) {
        this.setState({error: err});
    } else {
      TaskStore.createPromise(name, selectedDays, startHour, startMinute, endHour, endMinute, interval, intervalType, this.state.startDate).then(task => {
        // TODO: navigate to task
        window.location.assign('/#/task/'+task.id+'/edit');
      })
    }
  },
  render: function() {
    return (
      <div>
        <h2>Edit Task</h2>
        <form>
          <label htmlFor="TaskInput">Task Name:</label>
          <input className="u-full-width" ref="name" type="text" value={this.state.name} onChange={this.setName} />
          { (this.state.error.name && this.state.error.name.length > 0) ? <div className="error">{this.state.error.name }</div> : null }

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

          <label>Time</label>
          <div>
            <div>Start
              <input type="text" value={this.state.startHour} ref="startHour" onChange={this.handleStartHour}/> Hour <input type="text" value={this.state.startMinute} ref="startMinute" onChange={this.handleStartMinute}/> Minutes
            { (this.state.error.startHour && this.state.error.startHour.length > 0) ? <div className="error">{this.state.error.startHour}</div> : null }
            { (this.state.error.startMinute && this.state.error.startMinute.length > 0) ? <div className="error">{this.state.error.startMinute}</div> : null }
            </div>
            <div>End
              <input type="text" value={this.state.endHour} ref="endHour" onChange={this.handleEndHour}/> Hour <input type="text" value={this.state.endMinute} ref="endMinute" onChange={this.handleEndMinute}/> Minutes
            { (this.state.error.endHour && this.state.error.endHour.length > 0) ? <div className="error">{this.state.error.endHour}</div> : null }
            { (this.state.error.endMinute && this.state.error.endMinute.length > 0) ? <div className="error">{this.state.error.endMinute}</div> : null }
            </div>
          </div>

          <label htmlFor="TaskFilterIntervallInput">Intervall:</label>
          <label htmlFor="TaskFilterIntervallInput">start date</label>
          <DatePicker key="example1" selected={this.state.startDate} onChange={this.handleStartDateChange} /> 

          <div>     
            <span htmlFor="TaskFilterIntervallInput">every</span>
            <input type="text" value={this.state.interval} ref="interval" onChange={this.handleInterval}/>
            { (this.state.error.interval && this.state.error.interval.length > 0) ? <div className="error">{this.state.error.interval}</div> : null }
            <select ref="intervalType" value={this.state.intervalType} onChange={this.handleIntervalType}>
              <option value="0">Day</option>
              <option value="1">Week</option>
              <option value="2">Month</option>
            </select>
          </div>

          <input className="button-primary" type="submit" value="edit" onClick={this.create}/>
          <input className="button-primary button-clone" type="submit" value="clone" onClick={this.duplicate}/>
        </form>
      </div>
    );
  }
}));
