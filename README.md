# cordova-line-login-plugin
LineSDKを使用してLINEログインを簡単に実装するためのcordovaプラグイン。
LineSDK 4.0.2を使用

## Installation
    cordova plugin add xxxxx --variable LINE_CHANNEL_ID={your_line_channel_id}

## Supported Platforms
- iOS

## Example

ionicでの使用例
```js
angular.module('starter', ['ionic'])
  .run(function($ionicPlatform) {
    ・・・

    // initialize
    lineLogin.initialize();
  })
  .controller("LoginCtrl", function($scope) {
    $scope.onLineLogin = function() {
      lineLogin.login({},
        function(result) {
          console.log(result); // {userID:12345, displayName:'user name', pictureURL:'thumbnail url'}
        }, function(error) {
          console.log(error);
        });
    }
  });
```

