# cordova-line-login-plugin
A cordova plugin for easy implementation of LINE login using LineSDK.　　

The function login, logs out, acquires, verifies, and refreshes the access token. The version of LineSDK you are using is as follows.  

iOS：4.1.1

Android：4.0.8  

The flow until incorporation is as follows  
Create a business account corresponding to LINE login from "LINE BUSINESS CENTER". Select NATIVE_APP for Application Type.

### ios
1. "IOS Bundle ID" "iOS Scheme" is set from "LINE DEVELOPERS".
1. Install this plugin
1. Set "Keychain Sharing" to ON from "Capabilities" of xcode
1. Implementing the program

```
example)
iOS Bundle ID : com.example.sample
iOS Scheme : line3rdp.com.example.sample
```

### android
1. "Android Package Name" "Android Package Signature" "Android Scheme" is set from "LINE DEVELOPERS"
1. Install this plugin
1. Implementing the program

```
example)  
Android Package Name : com.example.sample
Android Package Signature : 11:22:33:44:55:66:77:88:99:aa:bb:cc:dd:ee:ff:gg:hh:ii:jj:kk
Android Scheme : com.example.sample://
```

## Installation
    cordova plugin add https://github.com/nrikiji/cordova-line-login-plugin.git --variable LINE_CHANNEL_ID={your_line_channel_id}

## Supported Platforms
- iOS
- Android

## LINE SDK
This plugin use the SDKs provided by LINE. More information about these in their documentation for [iOS](https://developers.line.me/ja/docs/ios-sdk/) or [Android](https://developers.line.me/ja/docs/android-sdk/)

## Example

Usage examples with ionic
```js
angular.module('starter', ['ionic'])
  .run(function($ionicPlatform) {
    ・・・

    // initialize
    lineLogin.initialize({channel_id: "your_chanel_id"});
  })
  .controller("LineCtrl", function($scope) {
    $scope.onLineLogin = function() {
      // login...
      lineLogin.login({},
        function(result) {
          console.log(result); // {userID:12345, displayName:'user name', pictureURL:'thumbnail url'}
        }, function(error) {
          console.log(error);
        });
    }

    $scope.onLineLogout = function() {
      // logout...
      lineLogin.logout(
        function(result) {
          console.log(result);
        }, function(error) {
          console.log(error);
        });
    }

    $scope.onLineGetAccessToken = function() {
      // get access token
      lineLogin.getAccessToken(
        function(result) {
          // success
          console.log(result); // {accessToken:'xxxxxxxx', expireTime: 123456789}
        }, function() {
          // failed
        });
    }

    $scope.onLineVerifyAccessToken = function() {
      // verify current access token
      lineLogin.verifyAccessToken(
        function() {
          // success
        }, function() {
          // failed
        });
    }

    $scope.onLineRefreshAccessToken = function() {
      // refresh access token
      lineLogin.verifyAccessToken(
        function(accessToken) {
          // success
        }, function() {
          // failed
        });
    }

  });
```

