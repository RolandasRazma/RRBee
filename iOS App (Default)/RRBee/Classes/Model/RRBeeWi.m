//
//  RRBeeWi.m
//  Bee
//
//  Created by Rolandas Razma on 16/08/2013.
//  Copyright (c) 2013 Rolandas Razma. All rights reserved.
//

#import "RRBeeWi.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <QuartzCore/QuartzCore.h>


@interface RRBeeWi () <EAAccessoryDelegate, NSStreamDelegate>

@end


const uint8_t BEE_FORWARD_HIGH[1]   = {1};
const uint8_t BEE_FORWARD_LOW[1]    = {0};

const uint8_t BEE_BACKWARD_HIGH[1]  = {3};
const uint8_t BEE_BACKWARD_LOW[1]   = {2};

const uint8_t BEE_LEFT_HIGH[1]      = {5};
const uint8_t BEE_LEFT_LOW[1]       = {4};

const uint8_t BEE_RIGHT_HIGH[1]     = {7};
const uint8_t BEE_RIGHT_LOW[1]      = {6};


@implementation RRBeeWi {
    EASession   *_session;    
}


#pragma mark -
#pragma mark RRBeeWi


+ (RRBeeWi *)sharedInstance {
    static RRBeeWi *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[RRBeeWi alloc] init];
    });
    return _sharedInstance;
}


- (void)openSession {
    NSArray *connectedAccessories = [[EAAccessoryManager sharedAccessoryManager] connectedAccessories];
    
    NSLog(@"openSession... %@", connectedAccessories);
    
    EAAccessory *accessory = nil;

    // Find accessory responding to protocol
    for ( accessory in connectedAccessories ){
        NSLog(@"accessory: %@", accessory);
        
        if ( [[accessory protocolStrings] containsObject:@"com.beewi.controlleur"] ) {
            NSLog(@"got accesory");
            break;
        }
    }
    
    // If found open session to it
    if ( accessory ) {
        _session = [[EASession alloc] initWithAccessory:accessory forProtocol:@"com.beewi.controlleur"];
        if ( _session ) {
            
            [_session.accessory setDelegate:self];
            
            [_session.inputStream setDelegate:self];
            [_session.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [_session.inputStream open];
            
            [_session.outputStream setDelegate:self];
            [_session.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [_session.outputStream open];
            
            NSLog(@"got session");
        }
    }
}


#pragma mark -
#pragma mark EAAccessoryDelegate


- (void)accessoryDidDisconnect:(EAAccessory *)accessory {
    NSLog(@"accessoryDidDisconnect");
    
    _session = nil;
}


#pragma mark -
#pragma mark NSStreamDelegate


- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)streamEvent {

    switch ( streamEvent ) {
        case NSStreamEventHasBytesAvailable: {
            // Process the incoming stream data.
            NSLog(@"NSStreamEventHasBytesAvailable");
            break;
        }
        case NSStreamEventHasSpaceAvailable: {
            // Send the next queued command.
            // NSLog(@"NSStreamEventHasSpaceAvailable");

            break;
        }
        case NSStreamEventNone: {
            NSLog(@"NSStreamEventNone");
            break;
        }
        case NSStreamEventOpenCompleted: {
            NSLog(@"NSStreamEventOpenCompleted");

            break;
        }
        case NSStreamEventErrorOccurred: {
            NSLog(@"NSStreamEventErrorOccurred");
            
//            [stream close];
//            [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//            [stream release];

            break;
        }
        case NSStreamEventEndEncountered: {
            NSLog(@"NSStreamEventEndEncountered");
            break;
        }
    }

}


- (void)turnLeft:(BOOL)left {
    [self write: (left?BEE_LEFT_HIGH:BEE_LEFT_LOW)];
}


- (void)turnRight:(BOOL)right {
    [self write: (right?BEE_RIGHT_HIGH:BEE_RIGHT_LOW)];
}


- (void)moveForward:(BOOL)forward {
    [self write: (forward?BEE_FORWARD_HIGH:BEE_FORWARD_LOW)];
}


- (void)moveBackward:(BOOL)backward {
    [self write: (backward?BEE_BACKWARD_HIGH:BEE_BACKWARD_LOW)];
}


- (void)write:(const uint8_t *)data {
    
    [_session.outputStream write: (const uint8_t *)data
                       maxLength: 1];
    
}


@end
