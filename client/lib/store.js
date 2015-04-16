var validator = require('validator');

export var UserStore = {
  validate: function(email, password){
    let vEmail    = validator.isEmail(email) ? '': 'invalid email';
    let vPassword = validator.isLength(password, 6, 130) ? '': 'password has to be 6 char long';
    return {email: vEmail, password: vPassword}
  },
  create: function(email, password){
    let vObj = this.validate(email, password);
    // server request
    // merge vObj with error if error
    return vObj;
  }
};

export var AuthStore = {
  validate: function(email, password){},
  create: function(email, password){
    // TODO: server request
    if(password == 'password'){
      localStorage.token = 'token'
      return '';
    }else{
      return 'password wrong';
    }
  },
  is_auth: function(){
    return localStorage.token && localStorage.token.length > 0
  },
  deauth: function(){
    localStorage.token = '';
  }
};
export var TaskStore = {};
export var DaskStore = {};
