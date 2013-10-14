//
//  LogicViewAppDelegate.m
//  LogicView
//
//  Created by Rene Hopf on 7/16/11.
//  Copyright 2011 Reroo. All rights reserved.
//

#import "LogicViewAppDelegate.h"

@implementation LogicViewAppDelegate

@synthesize window = _window,value,startStopButton,samplestext,SampleRatePopUpButton,allSampleRates,currentlySelectedSampleRate;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    sLogic = [[SaleaeLogic alloc]init];
    [sLogic setDelegate:self];
    [NSApp setDelegate:self];
    [value setStringValue:@""];
    /*allSampleRates = [NSArray arrayWithObjects:
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
                            nil];*/

    NSString *name;
    NSString *baudRate;
    allSampleRates = [[NSMutableArray alloc] initWithCapacity:10];
    SampleRate *sampleRate;
    for (int i = 0; i < 10; i++) {
        name = [NSString stringWithFormat:@"%d", i];
        baudRate = [NSString stringWithFormat:@"%d", 10 * i];
        
        sampleRate = [[SampleRate alloc] initWithName:name sampleRate:baudRate];
        
        [allSampleRates addObject:sampleRate];
    }

    //allPorts = [[NSMutableArray alloc] initWithCapacity:10];
    
    currentlySelectedSampleRate = [allSampleRates objectAtIndex:1]; // Any initial value
    
    
    //[SampleRate addItemsWithTitles:sampleRates];
    //[SampleRate setTarget:self];
    //[SampleRate setAction:@selector(sampleRateChanged:)];
}

-(void)sampleRateChanged:(id)sender
{
    NSLog(@"popUpAction");
}

- (void)dataArrived:(NSString *)deviceID data:(NSString *)data{
    [value setStringValue:data];
    [samplestext setStringValue:[NSString stringWithFormat:@"%i",samples]];
}

- (void)deviceConnected:(NSString *)deviceID{
    [startStopButton setEnabled:YES];
    [[self window] setTitle:@"LogicView - Connected"];
    [SampleRatePopUpButton setEnabled:YES];
}

- (void)deviceDisconnected:(NSString *)deviceID{
    [startStopButton setEnabled:NO];
    [[self window] setTitle:@"LogicView - Disconnected"];
    [sLogic stopPoll];
    [startStopButton setTitle:@"Start"];
    [value setStringValue:@""];
    [SampleRatePopUpButton setEnabled:YES];
}

- (void)deviceError:(NSString *)deviceID{
    NSLog(@"Device Error");
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:@"Logic could not keep up."];
    [alert setInformativeText:@"You can try a lower sample rate."];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:[self window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
    [startStopButton setTitle:@"Start"];
    [SampleRatePopUpButton setEnabled:YES];
    //todo: um polling in saleaelogic.mm kümmern, das wird hier nicht zurückgesetzt.
    
}

- (IBAction)botton:(id)sender {
    if([sLogic startPoll]){
        [startStopButton setTitle:@"Stop"];
        [SampleRatePopUpButton setEnabled:NO];
    }
    else{
        [value setStringValue:@""];
        [startStopButton setTitle:@"Start"];
        [SampleRatePopUpButton setEnabled:YES];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication{
    return YES;
}

@end
