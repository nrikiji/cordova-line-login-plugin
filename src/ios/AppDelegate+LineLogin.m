//
//  AppDelegate+LineLogin.m
//  Line Login
//
//  Created by nrikiji inc on 2017/09/01.
//
//

#import "AppDelegate+LineLogin.h"
#import <objc/runtime.h>

#if __has_include(<LineSDK/LineSDK-Swift.h>)
#import <LineSDK/LineSDK-Swift.h>
#elif __has_include("LineSDK-Swift.h")
#import "LineSDK-Swift.h"
#endif

#define CDVPluginHandleOpenURLNotification @"CDVPluginHandleOpenURLNotification"

@implementation AppDelegate (LineLogin)

static void swizzleMethod(Class class, SEL destinationSelector, SEL sourceSelector);

+ (void)load {
    swizzleMethod([AppDelegate class], @selector(application:openURL:options:), @selector(line_application_options:openURL:options:));
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleCordovaOpenURLNotification:)
                                                 name:CDVPluginHandleOpenURLNotification
                                               object:nil];
}

+ (void)handleCordovaOpenURLNotification:(NSNotification *)notification {
    NSURL *url = [notification object];
    if (!url || ![url isKindOfClass:[NSURL class]]) {
        return;
    }
    
    if ([url.scheme hasPrefix:@"line3rdp"]) {
        [[LineSDKLoginManager sharedManager] application:[UIApplication sharedApplication]
                                                    open:url
                                                 options:@{}];
    }
}

- (BOOL)line_application_options:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    NSRange range = [url.absoluteString rangeOfString:@"line3rdp"];
    if (range.location != NSNotFound) {
        BOOL handledByLine = [[LineSDKLoginManager sharedManager] application:app open:url options:options];
        [[NSNotificationCenter defaultCenter] postNotificationName:CDVPluginHandleOpenURLNotification object:url];
        return YES;
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
