#import "RootaccessPlugin.h"
#import <DTTJailbreakDetection/DTTJailbreakDetection.h>

#if __has_include(<rootaccess/rootaccess-Swift.h>)
#import <rootaccess/rootaccess-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "rootaccess-Swift.h"
#endif
/*
@implementation RootaccessPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRootaccessPlugin registerWithRegistrar:registrar];
}
@end
*/


@implementation RootAccessPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"root_access"
            binaryMessenger:[registrar messenger]];
  RootAccessPlugin* instance = [[RootAccessPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if ([@"isJailBroken" isEqualToString:call.method]) {
    result([NSNumber numberWithBool:[self isJailBroken]]);
  }else if ([@"canMockLocation" isEqualToString:call.method]) {
    //For now we have returned if device is Jail Broken or if it's not real device. There is no
    //strong detection of Mock location in iOS
    result([NSNumber numberWithBool:([self isJailBroken] || ![self isRealDevice])]);
  }else if ([@"isRealDevice" isEqualToString:call.method]) {
    result([NSNumber numberWithBool:[self isRealDevice]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (BOOL)isJailBroken{
//    return [self checkPaths] || [self checkSchemes] || [self canViolateSandbox];
    return [DTTJailbreakDetection isJailbroken];
}

- (BOOL) isRealDevice{
    return !TARGET_OS_SIMULATOR;
}

@end
