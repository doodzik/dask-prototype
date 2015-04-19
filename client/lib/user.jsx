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
      return {error: {email: '', password: ''}};
    },
  submit: function(e){
    e.preventDefault();
    let email = this.refs.email.getDOMNode().value;
    let password = this.refs.password.getDOMNode().value;
    let errorMsg = UserStore.create(email, password);
    if(errorMsg.email.length > 0 || errorMsg.password.length > 0){
      this.setState({error: errorMsg});
    } else {
      AuthStore.create(email, password);
      window.location.assign('/');
    }
  },
  render: function() {
    return (
      <div>
        <h2>Edit User</h2>
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
