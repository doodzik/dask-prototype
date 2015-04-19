var R         = require('ramda');
var Promise   = require("bluebird");
var validator = require('validator');
var request   = require('superagent');

export var UserStore = {
  validate: function(email, password){
    let vEmail    = validator.isEmail(email) ? '': 'invalid email';
    let vPassword = validator.isLength(password, 6, 130) ? '': 'password has to be 6 char long';
    return {email: vEmail, password: vPassword}
  },
  create: function(email, password, cb){
    let vObj = this.validate(email, password);
    var msg = '';
    if(vObj.email.length == 0 && vObj.password.length == 0){
      request.post('/api/users')
        .send({ email: email, password: password })
        .end(function(err, res){
            if(err){
              msg = {email: 'email already taken'};
            }
            cb(R.merge(vObj, msg))
          });
    } else {
      cb(vObj)
    }
  }
};

export var AuthStore = {
  validate: function(email, password){},
  create: function(email, password, cb){
    // TODO: server request
    var msg = '';
    request.post('/api/auth')
      .send({ email: email, password: password })
      .end(function(err, res){
          // Calling the end function will send the request
          if(err){
            msg = 'password or username is wrong';
          }else{
            localStorage.token = res.body.access_token
          }
          cb(msg);
        });
  },
  is_auth: function(){
    return localStorage.token && localStorage.token.length > 0
  },
  deauth: function(){
    localStorage.token = '';
  }
};

export var TaskStore = {
  all: function(cb){
    request.get('/api/tasks')
      .set('Authentication', localStorage.token)
      .end(function(err, res){
        cb(err, res.body);
      }); 
  }
};
export var DaskStore = {};
