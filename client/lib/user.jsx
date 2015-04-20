var Promise   = require("bluebird");
var React = require("react");
var R     = require('ramda');
import { needsAuth, needsDeauth } from './auth.jsx';
import { AuthStore, UserStore } from './store.js';

export var UserCreate = React.createClass(R.merge(needsDeauth, {
  getInitialState: function() {
    return {error: {email: '', password: ''}};
  },
  submit: function(e){
    e.preventDefault();
    let email = this.refs.email.getDOMNode().value;
    let password = this.refs.password.getDOMNode().value;
    UserStore.create(email, password, (errorMsg) => {
      if(errorMsg.email.length > 0 || errorMsg.password.length > 0){
        this.setState({error: errorMsg});
      } else {
        AuthStore.create(email, password, (errMsg) => {
           window.location.assign('/');
        });
      }
    });
  },
  render: function() {
    return (
      <div>
        <h2>Register</h2>
        <form>
          <label htmlFor="exampleEmailInput">Your email</label>
          <input className="u-full-width" ref="email" type="email" />
          { (this.state.error.email) ? <div className="error">{this.state.error.email}</div> : null}
          <label htmlFor="exampleEmailInput">Your password</label>
          <input className="u-full-width" ref="password" type="password" />
          { (this.state.error.password) ? <div className="error">{this.state.error.password}</div> : null}
          <input className="button-primary" type="submit" value="Submit" onClick={this.submit}/>
        </form>
      </div>
    );
  }
}));

export var UserEdit = React.createClass(R.merge(needsAuth, {
  getInitialState: function() {
      return {email: '', error: {email: '', password: ''}};
  },
  componentDidMount: function() {
    let userGet = Promise.promisify(UserStore.get);
    userGet().then((user) => {
      this.setState({ email: user.email });
    })
  },
  setEmail: function(){
    let email = this.refs.email.getDOMNode().value;
    this.setState({ email: email });
  },
  submit: function(e){
    e.preventDefault();
    let email           = this.refs.email.getDOMNode().value;
    let password        = this.refs.password.getDOMNode().value;
    let passwordConfirm = this.refs.passwordConfirm.getDOMNode().value;
    UserStore.put(email, password, passwordConfirm, (errorMsg) => {
        if(password.length == 0) { errorMsg.password = '' }
        if(errorMsg.email.length > 0 || errorMsg.password.length > 0 || errorMsg.passwordConfirm.length > 0){
          this.setState({error: errorMsg});
        } else {
          window.location.assign('/');
      }
    });
  },
  render: function() {
    return (
      <div>
        <h2>Edit User</h2>
        <form>
          <label htmlFor="exampleEmailInput">Your email</label>
          <input className="u-full-width" value={this.state.email} ref="email" type="email" onChange={this.setEmail} />
          { (this.state.error.email) ? <div className="error">{this.state.error.email}</div> : null}
          <label htmlFor="exampleEmailInput">Your password</label>
          <input className="u-full-width" ref="password" type="password" />
          { (this.state.error.password) ? <div className="error">{this.state.error.password}</div> : null}
          <label htmlFor="exampleEmailInput">confirm with your password</label>
          <input className="u-full-width" ref="passwordConfirm" type="password" />
          { (this.state.error.passwordConfirm) ? <div className="error">{this.state.error.passwordConfirm}</div> : null}
          <input className="button-primary" type="submit" value="Submit" onClick={this.submit}/>
        </form>
      </div>
    );
  }
}));
