var Promise = require("bluebird");
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
  all: function(){
    return new Promise(function (resolve) {
      request.get('/api/tasks')
      .set('Authentication', localStorage.token)
      .end(function(err, res){
        resolve(res.body);
      });
    })
  },
  validateInterval: function(startHour, startMinute, endHour, endMinute, interval){
    var obj = { startHour: '', startMinute: '', endHour: '', endMinute: '', interval: ''};
    if(startHour < 0 || startHour > 23) {
      obj['startHour'] = 'start hour has to be between 0 and 23';
    }
    if(startMinute < 0 || startMinute > 59) {
      obj['startMinute'] = 'start hour has to be between 0 and 23';
    }
    if(endHour < 0 || endHour > 23) {
      obj['endHour'] = 'end hour has to be between 0 and 23';
    }
    if(endMinute < 0 || endMinute > 59) {
      obj['endMinute'] = 'the end minute has to be between 0 and 59';
    }
    if(interval < 1 || interval > 99) {
      obj['interval'] = 'interval has to be between 1 and 99';
    }
    return obj;
  },
  validate: function(name, days){
    let msg = validator.isLength(name, 1, 130) ? '': 'name has to be 1 char long';
    return msg;
  },
  destroy: function(id){
    request.del('/api/tasks/'+id)
      .set('Authentication', localStorage.token)
      .end((err, res) => {})
  },
  createPromise: function(name, days, startHour, startMinute, endHour, endMinute, interval,intervalType, startDate, onetime){
    return new Promise(function (resolve) {
      request.post('/api/tasks')
        .set('Authentication', localStorage.token)
        .send({ name: name, days: days, startHour: startHour, startMinute: startMinute, endHour: endHour, endMinute: endMinute, interval: interval, intervalType: intervalType, startDate: startDate, onetime: onetime})
        .end((err, res) => {
          resolve(res.body);
        });
    });
  },
  create: function(name, days, startHour, startMinute, endHour, endMinute, interval,intervalType, startDate, onetime){
    request.post('/api/tasks')
      .set('Authentication', localStorage.token)
      .send({ name: name, days: days, startHour: startHour, startMinute: startMinute, endHour: endHour, endMinute: endMinute, interval: interval, intervalType: intervalType, startDate: startDate, onetime: onetime})
      .end((err, res) => {});
  },
  put: function(id, name, selectedDays, startHour, startMinute, endHour, endMinute, interval,intervalType, startDate, onetime){
    request.put('/api/tasks/'+id)
      .set('Authentication', localStorage.token)
      .send({ name: name, days: selectedDays, startHour: startHour, startMinute: startMinute, endHour: endHour, endMinute: endMinute, interval: interval, intervalType: intervalType, startDate: startDate, onetime: onetime})
      .end(function(err, res){
      });
  },
  get: function(id){
    return new Promise(function (resolve) {
      request.get('/api/tasks/'+id)
        .set('Authentication', localStorage.token)
        .end(function(err, res){
          resolve(res.body);
        });
    });
  }
};

export var DaskStore = {
  check: function(task){
    request.post('/api/tasks/daily')
      .set('Authentication', localStorage.token)
      .send({ id: task.id })
      .end((err, res) => {})
  },
  uncheck: function(task){
    request.del('/api/tasks/daily/'+task.id)
      .set('authentication', localStorage.token)
      .end((err, res) => {})
  }
};

export var TriggerStore = {
  v: [],
  all: function(){
    return new Promise(resolve => {
      request.get('/api/triggers')
        .set('authentication', localStorage.token)
        .end((err, res) => {
          resolve(res.body)
        })
    })
  },
  trigger: function(id) {
    return new Promise(resolve => {
      request.post('/api/trigger/'+id+'/trigger')
        .set('authentication', localStorage.token)
        .end((err, res) => {
          resolve(res.body)
        })
    })
  },
  get: function(name){
    return new Promise(resolve => {
      request.get('/api/triggers/'+ name)
        .set('authentication', localStorage.token)
        .end((err, res) => {
          resolve(res.body)
        })
    })
  },
  destroy: function(name){
    return new Promise(resolve => {
      request.del('/api/triggers/'+ name)
        .set('authentication', localStorage.token)
        .end((err, res) => {
          resolve(res.body)
        })
    })
  },
  destroyTask: function(id, name){
    return new Promise(resolve => {
      request.del('/api/trigger/'+id + '/tasks')
        .set('authentication', localStorage.token)
        .send({ name: name })
        .end((err, res) => {
          resolve(res.body)
        })
    })
  },
  createTask: function(id, name){
    return new Promise(resolve => {
      request.post('/api/trigger/'+id+'/tasks')
        .set('authentication', localStorage.token)
        .send({ name: name })
        .end((err, res) => {
          resolve(res.body)
        })
    })
  },
  create: function(name){
    return new Promise(resolve => {
      request.post('/api/triggers')
        .set('authentication', localStorage.token)
        .send({ name: name })
        .end((err, res) => {
          resolve(res.body)
        })
    })
  }
};
