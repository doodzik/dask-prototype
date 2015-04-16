var React        = require("react");
var Router       = require("react-router");
var Route        = Router.Route,
    DefaultRoute = Router.DefaultRoute,
    Link         = Router.Link,
    RouteHandler = Router.RouteHandler;

import { AuthCreate }               from './auth.jsx';
import { UserCreate, UserEdit} from './user.jsx';
import { DaskIndex }           from './dask.jsx';
import { TaskIndex, TaskEdit, TaskCreate } from './task.jsx';
import { About }               from './about.jsx';

import { AuthStore }           from './store.js';

var Nav = React.createClass({
  render: function(){
    return(
      <ul>
          <li><Link to="login">Login</Link></li>
          <li><Link to="register">Register</Link></li>
          <li><Link to="about">About</Link></li>
      </ul>
    )
  }
});

var NavAuthed = React.createClass({
  deauth: function(){
    AuthStore.deauth();
    window.location.assign('/');
  },
  render: function(){
    return(
      <ul>
        <li><Link to="dasks">Dasks</Link></li>
        <li><Link to="about">About</Link></li>
        <li><Link to="user/edit">UserEdit</Link></li>
        <li><Link to="/" onClick={this.deauth}>deauth</Link></li>
      </ul>
    )
  }
});

var IndexRoute = React.createClass({
    statics: {
      willTransitionTo: function (transition, params) {
        let path = AuthStore.is_auth() ? 'dasks' : 'login';
        transition.redirect(path);
      }
    },
    render: function(){}
});


var App = React.createClass({
  render: function () {
    return (
        <div>
          <nav>
            {(AuthStore.is_auth()) ? <NavAuthed/> : <Nav/>}
          </nav>
          {/* this is the important part */}

          <RouteHandler/>
        </div>
        );
  }
});

export var routes = (
    <Route name="app" path="/" handler={App}>
      <DefaultRoute handler={IndexRoute} />
      <Route name="login"  handler={AuthCreate}/>
      <Route name="register" handler={UserCreate}/>
      <Route name="dasks"  handler={DaskIndex}/>
      <Route name="tasks"  handler={TaskIndex}/>
      <Route name="task/create"  handler={TaskCreate}/>
      <Route name="task/:id/edit"  handler={TaskEdit}/>
      <Route name="user/edit"  handler={UserEdit}/>
      <Route name="about" handler={About}/>
      { /* <NotFoundRoute handler={IndexRoute}/> */ }
    </Route>
);
