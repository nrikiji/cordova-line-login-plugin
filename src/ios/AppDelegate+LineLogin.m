//
//  AppDelegate+LineLogin.m
//  Line Login
//
//  Created by nrikiji inc on 2017/09/01.
//
//

#import "AppDelegate+LineLogin.h"
#import <LineSDK/LineSDK.h>

@implementation AppDelegate (LineLogin)

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options
{
    return [[LineSDKLogin sharedInstance] handleOpenURL:url];
}

@end
