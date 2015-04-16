var React = require("react");
var R     = require('ramda');
import { AuthStore } from './store.js';

export var needsAuth = {
    statics: {
      willTransitionTo: function (transition, params) {
        if(!AuthStore.is_auth()){
          transition.redirect('/');
        }
      }
    }
}

export var needsDeauth = {
    statics: {
      willTransitionTo: function (transition, params) {
        if(AuthStore.is_auth()){
          transition.redirect('/');
        }
      }
    }
}

export var AuthCreate = React.createClass(R.merge(needsDeauth, {
  getInitialState: function() {
      return {error: ''};
    },
  submit: function(e){
    e.preventDefault();
    let email = this.refs.email.getDOMNode().value;
    let password = this.refs.password.getDOMNode().value;
    let errorMsg = AuthStore.create(email, password);
    console.log(errorMsg);
    if(errorMsg){
      this.setState({error: errorMsg});
    } else {
      window.location.assign('/');
    }
  },
  render: function() {
    return (
      <div>
        <h2>Login</h2>
        { (this.state.error) ? <div className="error">{this.state.error}</div> : null}
        <form>
          <label htmlFor="exampleEmailInput">Your email</label>
          <input className="u-full-width" ref="email" type="email" />
          <label htmlFor="exampleEmailInput">Your password</label>
          <input className="u-full-width" ref="password" type="password" />
          <input className="button-primary" type="submit" value="Submit" onClick={this.submit}/>
        </form>
      </div>
    );
  }
}));
