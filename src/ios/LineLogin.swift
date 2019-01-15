import Foundation
import LineSDK

@objc(LineLogin) class Line : CDVPlugin {
    
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
        LoginManager.shared.login(permissions: [.profile], in: self.viewController) {
            result in
            switch result {
            case .success(let loginResult):
                var data = ["userID":nil, "displayName":nil, "pictureURL":nil] as [String : Any?]
                if let displayName = loginResult.userProfile?.displayName {
                    data.updateValue(displayName, forKey: "displayName")
                }
                if let userID = loginResult.userProfile?.userID {
                    data.updateValue(userID, forKey: "userID")
                }
                if let pictureURL = loginResult.userProfile?.pictureURL {
                    data.updateValue(String(describing: pictureURL), forKey: "pictureURL")
                }

                let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:data as [AnyHashable : Any])
                self.commandDelegate.send(result, callbackId:command.callbackId)
            case .failure(let error):
                let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.errorDescription)
                self.commandDelegate.send(result, callbackId:command.callbackId)
            }
        }
    }

    func logout(_ command: CDVInvokedUrlCommand) {
        LoginManager.shared.logout { result in
            switch result {
            case .success:
                let result = CDVPluginResult(status: CDVCommandStatus_OK)
                self.commandDelegate.send(result, callbackId:command.callbackId)
            case .failure(let error):
                let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.errorDescription)
                self.commandDelegate.send(result, callbackId:command.callbackId)
            }
        }
    }

    func getAccessToken(_ command: CDVInvokedUrlCommand) {
        
        guard let currentAccessToken = AccessTokenStore.shared.current else {
            let result = CDVPluginResult(status: CDVCommandStatus_ERROR)
            commandDelegate.send(result, callbackId:command.callbackId)
            return
        }
        
        let data = ["accessToken":currentAccessToken.value, "expireTime":currentAccessToken.expiresAt.timeIntervalSince1970] as [String : Any?]
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:data as [AnyHashable : Any])
        commandDelegate.send(result, callbackId:command.callbackId)
    }
    
    func verifyAccessToken(_ command: CDVInvokedUrlCommand) {
        
        API.verifyAccessToken { (result) in
            switch result {
            case .success( _):
                let result = CDVPluginResult(status: CDVCommandStatus_OK)
                self.commandDelegate.send(result, callbackId:command.callbackId)
            case .failure( _):
                let result = CDVPluginResult(status: CDVCommandStatus_ERROR)
                self.commandDelegate.send(result, callbackId:command.callbackId)
            }
        }
    }
    
    func refreshAccessToken(_ command: CDVInvokedUrlCommand) {

        API.refreshAccessToken { (result) in
            switch result {
            case .success(let accessToken):
                let data = ["accessToken":accessToken.value, "expireTime":accessToken.expiresAt.timeIntervalSince1970] as [String : Any?]
                dump(data)
                let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:data as [AnyHashable : Any])
                self.commandDelegate.send(result, callbackId:command.callbackId)
            case .failure( _):
                let result = CDVPluginResult(status: CDVCommandStatus_ERROR)
                self.commandDelegate.send(result, callbackId:command.callbackId)
            }
        }
    }
    
}
