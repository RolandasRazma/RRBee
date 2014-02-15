//
//  RRAppDelegate.m
//  RRBee
//
//  Created by Rolandas Razma on 16/08/2013.
//  Copyright (c) 2013 Rolandas Razma. All rights reserved.
//

#import "RRAppDelegate.h"


@implementation RRAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // disable idle timer
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];

    // Override point for customization after application launch.
    return YES;
}


@end
