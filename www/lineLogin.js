'use strict';

var exec = require('cordova/exec');

var LineLogin = {

  initialize: function(param, onSuccess, onFail) {
    return exec(onSuccess, onFail, 'LineLogin', 'initialize', [param]);
  },

  // @TODO delete param because unnecessary
  login: function(param, onSuccess, onFail) {
    return exec(onSuccess, onFail, 'LineLogin', 'login', [param]);
  },

  // @TODO replace login
  login2: function(onSuccess, onFail) {
    return exec(onSuccess, onFail, 'LineLogin', 'login', []);
  },

  logout: function(onSuccess, onFail) {
    return exec(onSuccess, onFail, 'LineLogin', 'logout', []);
  },

  getAccessToken: function(onSuccess, onFail) {
    return exec(onSuccess, onFail, 'LineLogin', 'getAccessToken', []);
  },

  verifyAccessToken: function(onSuccess, onFail) {
    return exec(onSuccess, onFail, 'LineLogin', 'verifyAccessToken', []);
  },

  refreshAccessToken: function(onSuccess, onFail) {
    return exec(onSuccess, onFail, 'LineLogin', 'refreshAccessToken', []);
  }

};
module.exports = LineLogin;
