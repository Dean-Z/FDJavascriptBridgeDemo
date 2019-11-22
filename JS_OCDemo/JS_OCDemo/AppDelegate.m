//
//  AppDelegate.m
//  JS_OCDemo
//
//  Created by Jason on 2019/11/22.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "AppDelegate.h"
#import "WebController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    WebController *splash = [WebController new];
    self.window.rootViewController = splash;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
