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


@implementation YPViewController {
    __weak IBOutlet UIButton *_forwardButton;
    __weak IBOutlet UIButton *_backwardButton;
    __weak IBOutlet UIButton *_leftButton;
    __weak IBOutlet UIButton *_rightButton;
    __weak IBOutlet UISwitch *_lightsSwitch;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[RRBeeWi sharedInstance] openSession];
}


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


@end
