import Foundation
import LineSDK

@objc(LineLogin) class Line : CDVPlugin {
    
    struct ErrorCode {
        static let ParameterError = -1
        static let SDKError = -2
    }

    @objc func initialize(_ command: CDVInvokedUrlCommand) {
        
        let params = command.arguments[0] as AnyObject
        
        guard let channelID = params["channel_id"] as? String else {
            self.parameterError(command: command, description: "channel_id is required")
            return
        }
        
        LoginManager.shared.setup(channelID: channelID, universalLinkURL: nil)
        let result = CDVPluginResult(status: CDVCommandStatus_OK)
        commandDelegate.send(result, callbackId:command.callbackId)
    }
    
    func _login(_ command: CDVInvokedUrlCommand, options: LoginManagerOptions) {
        LoginManager.shared.login(permissions: [.profile, .openID, .email], in: self.viewController, options: options) {
            result in
            switch result {
            case .success(let loginResult):
                var data = ["userID":nil, "displayName":nil, "pictureURL":nil, "email":nil] as [String : Any?]
                
                data.updateValue(loginResult.userProfile?.displayName, forKey: "displayName")
                data.updateValue(loginResult.userProfile?.userID, forKey: "userID")
                data.updateValue(loginResult.accessToken.IDToken?.payload.email, forKey: "email")
                if let pictureURL = loginResult.userProfile?.pictureURL {
                    data.updateValue(String(describing: pictureURL), forKey: "pictureURL")
                }
                
                let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:data as [AnyHashable : Any])
                self.commandDelegate.send(result, callbackId:command.callbackId)
            case .failure(let error):
                self.sdkError(command: command, error: error)
            }
        }
    }
    
    @objc func loginWeb(_ command: CDVInvokedUrlCommand) {
        self._login(command, options: LoginManagerOptions.init(rawValue: LoginManagerOptions.onlyWebLogin.rawValue))
    }
    
    @objc func login(_ command: CDVInvokedUrlCommand) {
        self._login(command, options: LoginManagerOptions())
    }
    
    @objc func logout(_ command: CDVInvokedUrlCommand) {
        LoginManager.shared.logout { result in
            switch result {
            case .success:
                let result = CDVPluginResult(status: CDVCommandStatus_OK)
                self.commandDelegate.send(result, callbackId:command.callbackId)
            case .failure(let error):
                self.sdkError(command: command, error: error)
            }
        }
    }

    @objc func getAccessToken(_ command: CDVInvokedUrlCommand) {
        
        guard let currentAccessToken = AccessTokenStore.shared.current else {
            let result = CDVPluginResult(status: CDVCommandStatus_ERROR)
            commandDelegate.send(result, callbackId:command.callbackId)
            return
        }
        
        let data = ["accessToken":currentAccessToken.value, "expireTime":currentAccessToken.expiresAt.timeIntervalSince1970] as [String : Any?]
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:data as [AnyHashable : Any])
        commandDelegate.send(result, callbackId:command.callbackId)
    }
    
    @objc func verifyAccessToken(_ command: CDVInvokedUrlCommand) {
        
        API.verifyAccessToken { (result) in
            switch result {
            case .success( _):
                let result = CDVPluginResult(status: CDVCommandStatus_OK)
                self.commandDelegate.send(result, callbackId:command.callbackId)
            case .failure(let error):
                self.sdkError(command: command, error: error)
            }
        }
    }
    
    @objc func refreshAccessToken(_ command: CDVInvokedUrlCommand) {

        API.refreshAccessToken { (result) in
            switch result {
            case .success(let accessToken):
                let data = ["accessToken":accessToken.value, "expireTime":accessToken.expiresAt.timeIntervalSince1970] as [String : Any?]
                let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:data as [AnyHashable : Any])
                self.commandDelegate.send(result, callbackId:command.callbackId)
            case .failure(let error):
                self.sdkError(command: command, error: error)
            }
        }
    }
    
    private func parameterError(command: CDVInvokedUrlCommand, description: String) {
        let err = ["code":ErrorCode.ParameterError, "description": description] as [AnyHashable : Any]
        let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: err)
        self.commandDelegate.send(result, callbackId:command.callbackId)
    }
    
    private func sdkError(command: CDVInvokedUrlCommand, error: LineSDKError) {
        let description = error.errorDescription ?? ""
        let err = ["code":ErrorCode.SDKError, "sdkErrorCode":error.errorCode, "description": description] as [AnyHashable : Any]
        let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: err)
        self.commandDelegate.send(result, callbackId:command.callbackId)
    }
    
}
