//
//  AppDelegate+LineLogin.m
//  Line Login
//
//  Created by nrikiji inc on 2017/09/01.
//
//

#import "AppDelegate+LineLogin.h"
#import <objc/runtime.h>
@import LineSDKObjC;

@implementation AppDelegate (LineLogin)

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [[LineSDKLoginManager sharedManager] application:app open:url options:options];
}

@end
