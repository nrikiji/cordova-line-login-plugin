import Foundation
import LineSDK

@objc(LineLogin) class Line : CDVPlugin {
    
    var callbackId:String?
    // var apiClient:LineSDKAPI?

    func initialize(_ command: CDVInvokedUrlCommand) {
        
        let params = command.arguments[0] as AnyObject
        
        guard let channelID = params["channel_id"] as? String else {
            let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Parameter Error")
            self.commandDelegate.send(result, callbackId:command.callbackId)
            return
        }
        
        LoginManager.shared.setup(channelID: channelID, universalLinkURL: nil)
        let result = CDVPluginResult(status: CDVCommandStatus_OK)
        commandDelegate.send(result, callbackId:command.callbackId)
    }
    
    func login(_ command: CDVInvokedUrlCommand) {
        self.callbackId = command.callbackId
        
        LoginManager.shared.login(permissions: [.profile], in: self.viewController) {
            result in
            switch result {
            case .success(let loginResult):
                print(loginResult.accessToken.value)
            // Do other things you need with the login result
            case .failure(let error):
                dump(error)
            }
        }
        // LineSDKLogin.sharedInstance().start()
    }

    func loginWeb(_ command: CDVInvokedUrlCommand) {
        self.callbackId = command.callbackId
        // LineSDKLogin.sharedInstance().startWebLogin()
    }
    
    func logout(_ command: CDVInvokedUrlCommand) {
        let dispatchQueue = DispatchQueue(label: "logout")
//        apiClient?.logout(queue: dispatchQueue, completion: { (success, error) in
//            if success {
//                let result = CDVPluginResult(status: CDVCommandStatus_OK)
//                self.commandDelegate.send(result, callbackId:command.callbackId)
//            } else {
//                let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.debugDescription)
//                self.commandDelegate.send(result, callbackId:command.callbackId)
//            }
//        })
    }

    func getAccessToken(_ command: CDVInvokedUrlCommand) {
//        let currentAccessToken = apiClient?.currentAccessToken()
//        if currentAccessToken != nil {
//            let data = ["accessToken":currentAccessToken?.accessToken, "expireTime":currentAccessToken?.estimatedExpiredDate().timeIntervalSince1970] as [String : Any?]
//            let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:data)
//            commandDelegate.send(result, callbackId:command.callbackId)
//        } else {
//            let result = CDVPluginResult(status: CDVCommandStatus_ERROR)
//            commandDelegate.send(result, callbackId:command.callbackId)
//        }
    }
    
    func verifyAccessToken(_ command: CDVInvokedUrlCommand) {
//        let dispatchQueue = DispatchQueue(label: "verifyToken")
//        apiClient?.verifyToken(queue: dispatchQueue, completion: { (success, error) in
//            if (error != nil) {
//                let result = CDVPluginResult(status: CDVCommandStatus_ERROR)
//                self.commandDelegate.send(result, callbackId:command.callbackId)
//            } else {
//                let result = CDVPluginResult(status: CDVCommandStatus_OK)
//                self.commandDelegate.send(result, callbackId:command.callbackId)
//            }
//        })
    }
    
    func refreshAccessToken(_ command: CDVInvokedUrlCommand) {
//        apiClient?.refreshToken(with: apiClient?.currentAccessToken(), completion: { (success, error) in
//            if (error != nil) {
//                let result = CDVPluginResult(status: CDVCommandStatus_ERROR)
//                self.commandDelegate.send(result, callbackId:command.callbackId)
//            } else {
//                let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:success?.accessToken)
//                self.commandDelegate.send(result, callbackId: command.callbackId)
//            }
//        })
    }
    
//    func didLogin(_ login: LineSDKLogin, credential: LineSDKCredential?, profile: LineSDKProfile?, error: Error?) {
//
//        if error != nil {
//            let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.debugDescription)
//            commandDelegate.send(result, callbackId:self.callbackId)
//        } else {
//            var data = ["userID":nil, "displayName":nil, "pictureURL":nil] as [String : Any?]
//            if let displayName = profile?.displayName {
//                data.updateValue(displayName, forKey: "displayName")
//            }
//            if let userID = profile?.userID {
//                data.updateValue(userID, forKey: "userID")
//            }
//            if let pictureURL = profile?.pictureURL {
//                data.updateValue(String(describing: pictureURL), forKey: "pictureURL")
//            }
//            let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:data)
//            commandDelegate.send(result, callbackId:self.callbackId)
//        }
//    }
}
