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


@interface RRBeeWi : NSObject

+ (RRBeeWi *)sharedInstance;

- (void)openSession;

- (void)moveForward:(BOOL)forward;
- (void)moveBackward:(BOOL)backward;
- (void)turnLeft:(BOOL)left;
- (void)turnRight:(BOOL)right;

@end
