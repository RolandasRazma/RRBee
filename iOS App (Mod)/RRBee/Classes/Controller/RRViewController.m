//
//  RRViewController.m
//  RRBee
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

#import "RRViewController.h"
#import "RRBeeWi.h"


@implementation RRViewController {
    __weak IBOutlet UIButton *_forwardButton;
    __weak IBOutlet UIButton *_backwardButton;
    __weak IBOutlet UIButton *_leftButton;
    __weak IBOutlet UIButton *_rightButton;
    __weak IBOutlet UISwitch *_lightsSwitch;
}


#pragma mark -
#pragma mark UIViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(beeWiDidConnectNotification:)
                                                 name: RRBeeWiDidConnectNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(beeWiDidDisconnectNotification:)
                                                 name: RRBeeWiDidDisconnectNotification
                                               object: nil];
    
    
    [[RRBeeWi sharedInstance] openSession];
    
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RRBeeWiDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RRBeeWiDidDisconnectNotification object:nil];
}


#pragma mark -
#pragma mark YPViewController


- (IBAction)updateState {

    [[RRBeeWi sharedInstance] setShiftRegisterStateForQA: ((_forwardButton.isTracking   == YES) ? RRShiftRegisterStateHigh : RRShiftRegisterStateLow)
                                                      QB: ((_backwardButton.isTracking  == YES) ? RRShiftRegisterStateHigh : RRShiftRegisterStateLow)
                                                      QC: ((_leftButton.isTracking      == YES) ? RRShiftRegisterStateHigh : RRShiftRegisterStateLow)
                                                      QD: ((_rightButton.isTracking     == YES) ? RRShiftRegisterStateHigh : RRShiftRegisterStateLow)
                                                      QE: ((_lightsSwitch.isOn          == YES) ? RRShiftRegisterStateHigh : RRShiftRegisterStateLow)
                                                      QF: RRShiftRegisterStateLow
                                                      QG: RRShiftRegisterStateLow
                                                      QH: RRShiftRegisterStateLow];
    
}


- (void)beeWiDidConnectNotification:(NSNotification *)notification {
    [self.view setBackgroundColor: [UIColor greenColor]];
}


- (void)beeWiDidDisconnectNotification:(NSNotification *)notification {
    [self.view setBackgroundColor: [UIColor redColor]];
}


@end
