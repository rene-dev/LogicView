//
//  SaleaeLogic.h
//  LogicView
//
//  Created by Rene Hopf on 7/17/11.
//  Copyright 2011 Reroo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SaleaeLogicConnectionDelegate;
@interface SaleaeLogic : NSObject{
    id <SaleaeLogicConnectionDelegate> delegate;
    NSTimer *pollTimer;
    BOOL isConnected;
}

- (BOOL)startPoll;
- (BOOL)stopPoll;
- (void)poll;

@property (nonatomic,retain) NSTimer *pollTimer;
@property (nonatomic) BOOL isConnected;
@property (nonatomic, assign) id <SaleaeLogicConnectionDelegate> delegate;

@end

@protocol SaleaeLogicConnectionDelegate
@optional
- (void)deviceConnected:(NSString *)deviceID;
- (void)deviceDisconnected:(NSString *)deviceID;
- (void)deviceError:(NSString *)deviceID;
- (void)dataArrived:(NSString *)deviceID data:(NSString *)data;

@end
