'use strict';

var exec = require('cordova/exec');

var LineLogin = {

  initialize: function(param, onSuccess, onFail) {
    return exec(onSuccess, onFail, 'LineLogin', 'initialize', [param]);
  },
  
  login: function(param, onSuccess, onFail) {
    return exec(onSuccess, onFail, 'LineLogin', 'login', [param]);
  },

  logout: function(onSuccess, onFail) {
    return exec(onSuccess, onFail, 'LineLogin', 'logout', []);
  }

};
module.exports = LineLogin;
