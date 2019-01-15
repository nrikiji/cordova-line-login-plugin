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

static void swizzleMethod(Class class, SEL destinationSelector, SEL sourceSelector);

+(void)load {
    swizzleMethod([AppDelegate class], @selector(application:openURL:options:), @selector(line_application_options:openURL:options:));
}

- (BOOL)line_application_options: (UIApplication *)app openURL: (NSURL *)url options: (NSDictionary *)options {
    NSRange range = [url.absoluteString rangeOfString:@"line3rdp"];
    if (range.location != NSNotFound) {
        return [[LineSDKLoginManager sharedManager] application:app open:url options:options];
    } else {
        return [self line_application_options:app openURL:url options:options];
    }
}

static void swizzleMethod(Class class, SEL destinationSelector, SEL sourceSelector) {
    Method destinationMethod = class_getInstanceMethod(class, destinationSelector);
    Method sourceMethod = class_getInstanceMethod(class, sourceSelector);

    if (class_addMethod(class, destinationSelector, method_getImplementation(sourceMethod), method_getTypeEncoding(sourceMethod))) {
        class_replaceMethod(class, destinationSelector, method_getImplementation(destinationMethod), method_getTypeEncoding(destinationMethod));
    } else {
        method_exchangeImplementations(destinationMethod, sourceMethod);
    }
}

@end
