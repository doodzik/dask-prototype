var React = require("react");
// import { CrudActions } from './crud_actions.js';

export var Index = React.createClass({
  click: function(){
    // CrudActions.addItem('this is an item');
  },
  render: function() {
    return (
      <div onClick={this.click}>
        Hello, Index! 
      </div>
    );
  }
});

