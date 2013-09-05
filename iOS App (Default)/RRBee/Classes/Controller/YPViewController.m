//
//  YPViewController.m
//  Bee
//
//  Created by Rolandas Razma on 16/08/2013.
//  Copyright (c) 2013 Rolandas Razma. All rights reserved.
//
//
//  ExternalAccessory.framework
//
//  <key>UISupportedExternalAccessoryProtocols</key>
//  <array>
//      <string>com.beewi.controlleur</string>
//  </array>

#import "YPViewController.h"
#import "RRBeeWi.h"


@implementation YPViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[RRBeeWi sharedInstance] openSession];
}


- (IBAction)turnLeft {
    [[RRBeeWi sharedInstance] turnLeft:YES];
}


- (IBAction)turnLeftEnd {
    [[RRBeeWi sharedInstance] turnLeft:NO];
}


- (IBAction)turnRight {
    [[RRBeeWi sharedInstance] turnRight:YES];
}


- (IBAction)turnRightEnd {
    [[RRBeeWi sharedInstance] turnRight:NO];
}


- (IBAction)moveForward {
    [[RRBeeWi sharedInstance] moveForward:YES];
}


- (IBAction)moveForwardEnd {
    [[RRBeeWi sharedInstance] moveForward:NO];
}


- (IBAction)moveBackward {
    [[RRBeeWi sharedInstance] moveBackward:YES];
}


- (IBAction)moveBackwardEnd {
    [[RRBeeWi sharedInstance] moveBackward:NO];
}


@end
