var React = require("react");
var Router = require("react-router");
var Route = Router.Route,
    DefaultRoute = Router.DefaultRoute,
    Link=Router.Link,
    RouteHandler = Router.RouteHandler;

import { Index } from './index.jsx';
// import { Show } from './show.jsx';
// import { Edit } from './edit.jsx';
// import { Create } from './create.jsx';
// import { Catalog } from './crud_index.jsx';

var App = React.createClass({
  render: function () {
    return (
        <div>
          <nav>
            <ul>
              <li><Link to="index">index</Link></li>
            </ul>
          </nav>

          {/* this is the important part */}

          <RouteHandler/>
        </div>
        );
  }
});

export var routes = (
    <Route name="app" path="/" handler={App}>
      <Route name="index" handler={Index}/>
    </Route>
);
