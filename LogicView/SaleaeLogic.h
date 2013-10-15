//
//  SaleaeLogic.h
//  LogicView
//
//  Created by Rene Hopf on 7/17/11.
//  Copyright 2011 Reroo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SaleaeLogicDelegate;
@interface SaleaeLogic : NSObject{
    id <SaleaeLogicDelegate> delegate;
    BOOL isConnected; //Logic device is connected
    BOOL isReading;   //We are reading from the device
}

- (BOOL)startPoll;
- (BOOL)stopPoll;
- (void)poll;
- (void)hallo:(unsigned char*)data length:(unsigned int)length;

@property (nonatomic) BOOL isConnected;
@property (nonatomic, assign) id <SaleaeLogicDelegate> delegate;

@end

@protocol SaleaeLogicDelegate

- (void)deviceConnected:(NSString *)deviceID;
- (void)deviceDisconnected:(NSString *)deviceID;
- (void)deviceError:(NSString *)deviceID;
- (void)dataArrived:(NSString *)deviceID data:(NSString *)data;
- (int)trigger:(unsigned char*)data length:(unsigned int)length channel:(int)ch rising:(BOOL)fl;

@end
