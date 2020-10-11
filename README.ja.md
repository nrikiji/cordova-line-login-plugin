# cordova-line-login-plugin
LineSDKを使用してLINEログインを簡単に実装するためのcordovaプラグイン。　　

機能はログイン、ログアウト、アクセストークンの取得・検証・リフレッシュを行う。使用しているLineSDKのバージョンは以下のとおり。  

iOS：5.5.1  
Android：5.3.1  

cordova >= 7.1.0  
cordova-ios >= 4.5.0  
cordova-android >= 8.0.0  

組み込みまでの流れは以下の通り  
「LINE BUSINESS CENTER」からLINEログインに対応したビジネスアカウントを作成。Application TypeはNATIVE_APPを選択。

### ios
1. 「LINE DEVELOPERS」より「iOS Bundle ID」「iOS Scheme」を設定。
1. swift5を使用する場合、config.xmlにバージョン指定（デフォルトはswift4）
1. 当プラグインをインストール。
1. プログラムの実装

```
例)swift5を使用する場合
config.xml  
<platform name="ios">
  <preference name="UseSwiftLanguageVersion" value="5" />
</platform>
```

### android
1. 「LINE DEVELOPERS」より「Android Package Name」「Android Package Signature」「Android Scheme」を設定。
1. 当プラグインをインストール。
1. プログラムの実装

```
例)  
Android Package Name : com.example.sample
Android Package Signature : 11:22:33:44:55:66:77:88:99:aa:bb:cc:dd:ee:ff:gg:hh:ii:jj:kk
Android Scheme : com.example.sample://
```

## Requirement
https://github.com/akofman/cordova-plugin-add-swift-support  

## Installation
```
cordova plugin add cordova-line-login-plugin
```

## Supported Platforms
- iOS (>=10.0)
- Android

## LINE SDK
このプラグインはLINEが提供するSDKを使用しています。これらの詳細はドキュメントを確認下さい。[iOS](https://developers.line.me/ja/docs/ios-sdk/) or 
[Android](https://developers.line.me/ja/docs/android-sdk/)

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

ionicで使う場合は、[ionic-nativeのドキュメント](https://ionicframework.com/docs/native/line-login)を参考にしてください。

### Error Code
errorコールバックでは以下の形式のエラーを返します
```
{
  code: -1: パラメータが不正です, -2:SDKがエラーを返しました, -3: 不明なエラー
  sdkErrorCode: SDKの返すエラーコード
  description: エラーメッセージ
}
```

## capacitorで使うには

### install
```
$ npm install cordova-line-login-plugin
```

### iOS configuration

capcitorでAppDelegateとinfo.plistを上書きまたは値を追加する方法が見つからないため以下の対応をしてください。   
iosディレクトリを作り直すたびに対応が必要となるためご注意ください。  

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
