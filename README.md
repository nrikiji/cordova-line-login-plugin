# cordova-line-login-plugin
A cordova plugin for easy implementation of LINE login using LineSDK.　　

The function login, logs out, acquires, verifies, and refreshes the access token. The version of LineSDK you are using is as follows.  

iOS：5.5.1  
Android：5.3.1  

cordova >= 7.1.0  
cordova-ios >= 4.5.0  
cordova-android >= 8.0.0  

The flow until incorporation is as follows  
Create a business account corresponding to LINE login from "LINE BUSINESS CENTER". Select NATIVE_APP for Application Type.

### ios
1. "IOS Bundle ID" "iOS Scheme" is set from "LINE DEVELOPERS".
1. When using swift5, specify version in config.xml. (Default is swift4)
1. Install this plugin
1. Implementing the program

```
example)When using swift5
config.xml  
<platform name="ios">
  <preference name="UseSwiftLanguageVersion" value="5" />
</platform>
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

## Requirement
https://github.com/akofman/cordova-plugin-add-swift-support  

## Installation
cordova plugin add cordova-line-login-plugin

## Supported Platforms
- iOS
- Android

## LINE SDK
This plugin use the SDKs provided by LINE. More information about these in their documentation for [iOS](https://developers.line.me/ja/docs/ios-sdk/) or [Android](https://developers.line.me/ja/docs/android-sdk/)

## Usage

### Example

```js
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady() {
  lineLogin.initialize({channel_id: "1565553788"});
}

function onLineLogin() {
  // login...
  lineLogin.login(
   function(result) {
     console.log(result); // {userID:12345, displayName:'user name', pictureURL:'thumbnail url'}
   }, function(error) {
     console.log(error);
   });
}

function onLineLoginWeb {
  // login with web...(iOS only)
  lineLogin.loginWeb(
    function(result) {
      console.log(result); // {userID:12345, displayName:'user name', pictureURL:'thumbnail url'}
    }, function(error) {
      console.log(error);
    });
}

function onLineLogout {
  // logout...
  lineLogin.logout(
    function(result) {
      console.log(result);
    }, function(error) {
      console.log(error);
    });
}

function onLineGetAccessToken() {
  // get access token
  lineLogin.getAccessToken(
    function(result) {
      // success
      console.log(result); // {accessToken:'xxxxxxxx', expireTime: 123456789}
    }, function(error) {
      // failed
    });
}

function onLineVerifyAccessToken() {
  // verify current access token
  lineLogin.verifyAccessToken(
    function() {
      // success
    }, function(error) {
      // failed
    });
}

function onLineRefreshAccessToken() {
  // refresh access token
  lineLogin.verifyAccessToken(
    function(accessToken) {
      // success
    }, function(error) {
      // failed
    });
}
```

If you want to use it with ionic, please refer to the [ionic-native documentation](https://ionicframework.com/docs/native/line-login).

### Error Code
error callback returns an error of the form 　
```
{
  code: -1: Invalid parameter, -2:SDK returned an error, -3: Unknown error
  sdkErrorCode: Error code returned by SDK
  description: Error message
}
```

## use in capacitors

### install
```
$ npm install cordova-line-login-plugin
```

### iOS configuration

Overwrite AppDelegate and info.plist in capcitor or add value Please take the following actions as I have not found a way to do so.  
Please note that you will have to deal with this every time you recreate the ios directory.  

In file ios/App/App/AppDelegate.swift add or replace the following:
```
+ import LineSDK
  [...]
   func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
-   return CAPBridge.handleOpenUrl(url, options)
+     if CAPBridge.handleOpenUrl(url, options) {
+        return LoginManager.shared.application(app, open: url)
+     } else {
+         return false
+     }
   }
```

Add the following in the ios/App/App/info.plist file:  
```
+ <key>CFBundleURLTypes</key>
+ <array>
+     <dict>
+         <key>CFBundleTypeRole</key>
+         <string>Editor</string>
+         <key>CFBundleURLSchemes</key>
+         <array>
+             <string>line3rdp.$(PRODUCT_BUNDLE_IDENTIFIER)</string>
+         </array>
+     </dict>
+ </array>
+ <key>LSApplicationQueriesSchemes</key>
+ <array>
+     <string>lineauth2</string>
+ </array>
```

