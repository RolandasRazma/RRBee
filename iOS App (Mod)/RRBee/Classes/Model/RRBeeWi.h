//
//  RRBeeWi.h
//  Bee
//
//  Created by Rolandas Razma on 16/08/2013.
//  Copyright (c) 2013 Rolandas Razma. All rights reserved.
//
//
//  Add framework
//  ExternalAccessory.framework
//
//  add to Info.plist
//  <key>UISupportedExternalAccessoryProtocols</key>
//  <array>
//      <string>com.beewi.controlleur</string>
//  </array>

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RRShiftRegisterState) {
    RRShiftRegisterStateLow = 0,
    RRShiftRegisterStateHigh= 1,
};

@interface RRBeeWi : NSObject

+ (RRBeeWi *)sharedInstance;

- (void)openSession;
- (void)setShiftRegisterStateForQA:(RRShiftRegisterState)QA QB:(RRShiftRegisterState)QB QC:(RRShiftRegisterState)QC QD:(RRShiftRegisterState)QD QE:(RRShiftRegisterState)QE QF:(RRShiftRegisterState)QF QG:(RRShiftRegisterState)QG QH:(RRShiftRegisterState)QH;

@end
