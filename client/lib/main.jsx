var React  = require("react");
var Router = require("react-router");
import { routes } from './router.jsx';

Router.run(routes, Router.HistoryLocation, function (Handler) {
    React.render(<Handler/>, document.body);
});
