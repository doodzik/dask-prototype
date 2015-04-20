var React  = require("react");
var Router = require("react-router");
import { routes } from './router.jsx';

// Router.run(routes, Router.HistoryLocation, function (Handler) {
//     React.render(<Handler/>, document.body);
// });

// Router.run(routes, function (Handler) {
//   React.render(<Handler/>, document.body);
// }); 

Router.run(routes, function (Handler, state) {
  var params = state.params;
  React.render(<Handler params={params}/>, document.body);
});
