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
            
            [self setShiftRegisterStateForQA: RRShiftRegisterStateLow
                                          QB: RRShiftRegisterStateLow
                                          QC: RRShiftRegisterStateLow
                                          QD: RRShiftRegisterStateLow
                                          QE: RRShiftRegisterStateLow
                                          QF: RRShiftRegisterStateLow
                                          QG: RRShiftRegisterStateLow
                                          QH: RRShiftRegisterStateLow];
        }
    }
}


- (void)setShiftRegisterStateForQA:(RRShiftRegisterState)QA QB:(RRShiftRegisterState)QB QC:(RRShiftRegisterState)QC QD:(RRShiftRegisterState)QD QE:(RRShiftRegisterState)QE QF:(RRShiftRegisterState)QF QG:(RRShiftRegisterState)QG QH:(RRShiftRegisterState)QH {
    
    #define SERIAL_HIGH         1   // (Serial) Input for the next pin that gets shifted in.
    #define SERIAL_LOW          0
    #define SERIAL_CLOCK_HIGH   5   // (Serial Clock) When this pin is pulled high, it will shift the register.
    #define SERIAL_CLOCK_LOW    4
    #define REGISTER_CLOCK_HIGH 7   // (Register Clock) Needs to be pulled high to set the output to the new shift register values, This must be pulled high directly after SRCLK has gone LOW again.
    #define REGISTER_CLOCK_LOW  6

    uint8_t data[27];
    data[0] = REGISTER_CLOCK_LOW;

    data[1] = SERIAL_CLOCK_LOW;
    data[2] = (QH==RRShiftRegisterStateHigh?SERIAL_HIGH:SERIAL_LOW);
    data[3] = SERIAL_CLOCK_HIGH;
    
    data[4] = SERIAL_CLOCK_LOW;
    data[5] = (QG==RRShiftRegisterStateHigh?SERIAL_HIGH:SERIAL_LOW);
    data[6] = SERIAL_CLOCK_HIGH;
    
    data[7] = SERIAL_CLOCK_LOW;
    data[8] = (QF==RRShiftRegisterStateHigh?SERIAL_HIGH:SERIAL_LOW);
    data[9] = SERIAL_CLOCK_HIGH;
    
    data[10] = SERIAL_CLOCK_LOW;
    data[11] = (QE==RRShiftRegisterStateHigh?SERIAL_HIGH:SERIAL_LOW);
    data[12] = SERIAL_CLOCK_HIGH;
    
    data[13] = SERIAL_CLOCK_LOW;
    data[14] = (QD==RRShiftRegisterStateHigh?SERIAL_HIGH:SERIAL_LOW);
    data[15] = SERIAL_CLOCK_HIGH;
    
    data[16] = SERIAL_CLOCK_LOW;
    data[17] = (QC==RRShiftRegisterStateHigh?SERIAL_HIGH:SERIAL_LOW);
    data[18] = SERIAL_CLOCK_HIGH;
    
    data[19] = SERIAL_CLOCK_LOW;
    data[20] = (QB==RRShiftRegisterStateHigh?SERIAL_HIGH:SERIAL_LOW);
    data[21] = SERIAL_CLOCK_HIGH;

    data[22] = SERIAL_CLOCK_LOW;
    data[23] = (QA==RRShiftRegisterStateHigh?SERIAL_HIGH:SERIAL_LOW);
    data[24] = SERIAL_CLOCK_HIGH;

    data[25] = REGISTER_CLOCK_HIGH;
    data[26] = REGISTER_CLOCK_LOW;

    NSLog(@"%i%i%i%i%i%i%i%i", data[2], data[5], data[8], data[11], data[14], data[17], data[20], data[23]);
    
    [_session.outputStream write: (const uint8_t *)data
                       maxLength: 27];
    
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


@end
