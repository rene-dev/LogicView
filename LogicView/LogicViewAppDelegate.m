//
//  LogicViewAppDelegate.m
//  LogicView
//
//  Created by Rene Hopf on 7/16/11.
//  Copyright 2011 Reroo. All rights reserved.
//

#import "LogicViewAppDelegate.h"

@implementation LogicViewAppDelegate

@synthesize window = _window,value,startStopButton,connected;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    sLogic = [[SaleaeLogic alloc]init];
    [sLogic setDelegate:self];
    [NSApp setDelegate:self];
    [value setStringValue:@""];
}

- (void)dataArrived:(NSString *)deviceID data:(NSString *)data{
    [value setStringValue:data];
}

- (void)deviceConnected:(NSString *)deviceID{
    [startStopButton setEnabled:YES];
    [connected setStringValue:@"connected"];
}

- (void)deviceDisconnected:(NSString *)deviceID{
    [startStopButton setEnabled:NO];
    [connected setStringValue:@"disconnected"];
    [sLogic stopPoll];
    [startStopButton setTitle:@"Start"];
    [value setStringValue:@""];
}

- (void)deviceError:(NSString *)deviceID{
    NSLog(@"Device Error");
}

- (IBAction)botton:(id)sender {
    if([sLogic startPoll])
        [startStopButton setTitle:@"Stop"];
    else if([sLogic stopPoll]){
        [value setStringValue:@""];
        [startStopButton setTitle:@"Start"];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication{
    return YES;
}

@end
