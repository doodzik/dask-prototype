var R         = require('ramda');
var validator = require('validator');
var request   = require('superagent');

export var UserStore = {
  validate: function(email, password){
    let vEmail    = validator.isEmail(email) ? '': 'invalid email';
    let vPassword = validator.isLength(password, 6, 130) ? '': 'password has to be 6 char long';
    return {email: vEmail, password: vPassword}
  },
  validatePassword: function(password){
return validator.isLength(password, 6, 130) ? '': 'password has to be 6 char long';
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
  },
  put: function(email, password, passwordConfirm, cb){
    let vObj = R.merge(this.validate(email, password), { passwordConfirm: this.validatePassword(passwordConfirm) })
    var msg = '';
    if(vObj.email.length == 0 && (vObj.password.length == 0 || password.length == 0) && vObj.passwordConfirm.length == 0){
      request.put('/api/users')
        .send({ email: email, password: password, password_confirm: passwordConfirm })
        .set('Authentication', localStorage.token)
        .end(function(err, res){
            if(err){
              msg = JSON.parse(err.response.text);
            }
            cb(R.merge(vObj, msg))
          });
    } else {
      cb(vObj)
    }
  },

  get: function(cb){
      request.get('/api/user')
        .set('Authentication', localStorage.token)
        .end(function(err, res){
            cb(err, res.body);
          });
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
  },
  validate: function(name,days){
    let msg = validator.isLength(name, 1, 130) ? '': 'name has to be 1 char long';
    return msg;
  },
  destroy: function(id){
    request.del('/api/tasks/'+id)
      .set('Authentication', localStorage.token)
      .end((err, res) => {})
  },
  create: function(name, days){
    request.post('/api/tasks')
      .set('Authentication', localStorage.token)
      .send({ name: name, days: days })
      .end((err, res) => {});
  },
  put: function(id, name, selectedDays){
    request.put('/api/tasks/'+id)
      .set('Authentication', localStorage.token)
      .send({ name: name, days: selectedDays })
      .end(function(err, res){
      });
  },
  get: function(id, cb){
    request.get('/api/tasks/'+id)
      .set('Authentication', localStorage.token)
      .end(function(err, res){
        cb(err, res.body);
      });
  }
};
export var DaskStore = {
  check: function(id){
    request.post('/api/tasks/daily')
      .set('Authentication', localStorage.token)
      .send({ id: id })
      .end((err, res) => {})
  },
  uncheck: function(id){
    request.del('/api/tasks/daily/'+id)
      .set('authentication', localStorage.token)
      .end((err, res) => {})
  }
};
