//
//  LogicViewAppDelegate.m
//  LogicView
//
//  Created by Rene Hopf on 7/16/11.
//  Copyright 2011 Reroo. All rights reserved.
//

#import "LogicViewAppDelegate.h"

@implementation LogicViewAppDelegate

@synthesize window = _window,value,startStopButton,samplestext,textField;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    sLogic = [[SaleaeLogic alloc]init];
    [sLogic setDelegate:self];
    [NSApp setDelegate:self];
    [value setStringValue:@""];
    NSArray* allSampleRates = [NSArray arrayWithObjects:
                            @"25 kHz",
                            @"50 kHz",
                            @"100 kHz",
                            @"200 kHz",
                            @"250 kHz",
                            @"500 kHz",
                            @"1 MHz",
                            @"2 MHz",
                            @"4 MHz",
                            @"8 MHz",
                            @"12 MHz",
                            @"16 MHz",
                            @"24 MHz",
                            nil];
    
    NSArray* allChannels = [NSArray arrayWithObjects:
                               @"Channel 1",
                               @"Channel 2",
                               @"Channel 3",
                               @"Channel 4",
                               @"Channel 5",
                               @"Channel 6",
                               @"Channel 7",
                               @"Channel 8",
                               nil];
    
    [sampleRate addItemsWithTitles:allSampleRates];
    [triggerChannel addItemsWithTitles:allChannels];
    [triggerPos setContinuous:YES];
    [sLogic setTriggerRising:YES];
    [sLogic setTriggerChannel:0];
    [sLogic setTriggerPos:5];
    [textField setStringValue:@"1\n2\n3\n4\n5\n6\n7\n8\n"];
}

-(void)sampleRateChanged:(id)sender
{
    NSLog(@"popUpAction");
}

- (void)dataArrived:(NSString *)deviceID data:(NSString *)data{
    //[value setStringValue:data];
    //[samplestext setStringValue:[NSString stringWithFormat:@"%i",samples]];
    [textField setStringValue:data];
}

- (void)deviceConnected:(NSString *)deviceID{
    [startStopButton setEnabled:YES];
    [[self window] setTitle:@"LogicView - Connected"];
    [sampleRate setEnabled:YES];
}

- (void)deviceDisconnected:(NSString *)deviceID{
    [startStopButton setEnabled:NO];
    [[self window] setTitle:@"LogicView - Disconnected"];
    [sLogic stopPoll];
    [startStopButton setTitle:@"Start"];
    [value setStringValue:@""];
    [sampleRate setEnabled:YES];
}

- (void)deviceError:(NSString *)deviceID{
    NSLog(@"Device Error");
    [self performSelectorOnMainThread:@selector(displayError) withObject:nil waitUntilDone:NO];
    [startStopButton setTitle:@"Start"];
    [sampleRate setEnabled:YES];
    //todo: um polling in saleaelogic.mm kümmern, das wird hier nicht zurückgesetzt. ist das so?
    
}

- (void)displayError{
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:@"Logic could not keep up."];
    [alert setInformativeText:@"You can try a lower sample rate."];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:[self window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)updateTrigger:(id)sender {
    if ([triggerEdge selectedSegment] == 0) {
        [sLogic setTriggerRising:YES];
    }else{
        [sLogic setTriggerRising:NO];
    }
    [sLogic setTriggerChannel:[triggerChannel indexOfSelectedItem]];
    [sLogic setTriggerPos:[triggerPos floatValue]];
}

- (IBAction)botton:(id)sender {
    if([sLogic startPoll:[sampleRate indexOfSelectedItem]]){
        [startStopButton setTitle:@"Stop"];
        [sampleRate setEnabled:NO];
    }
    else{
        [value setStringValue:@""];
        [startStopButton setTitle:@"Start"];
        [sampleRate setEnabled:YES];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication{
    return YES;
}

@end
