//
//  LogicViewAppDelegate.h
//  LogicView
//
//  Created by Rene Hopf on 7/16/11.
//  Copyright 2011 Reroo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SaleaeLogic.h"
#import "SampleRate.h"
@class SampleRate;

@interface LogicViewAppDelegate : NSObject <NSApplicationDelegate,SaleaeLogicDelegate> {
    NSWindow *_window;
    SaleaeLogic *sLogic;
    IBOutlet NSButton *startStopButton;
    IBOutlet NSTextField *value;
    IBOutlet NSTextField *samplestext;
    IBOutlet NSPopUpButton *SampleRatePopUpButton;
    int samples;
    NSMutableArray* allSampleRates;
    SampleRate *currentlySelectedSampleRate;
}
- (IBAction)botton:(id)sender;
- (void)sampleRateChanged:(id)sender;

@property (nonatomic, retain) SampleRate *currentlySelectedSampleRate;
@property (nonatomic,copy) NSMutableArray* allSampleRates;
@property (strong) IBOutlet NSWindow *window;
@property (nonatomic,retain) IBOutlet NSTextField *value;
@property (nonatomic,retain) IBOutlet NSTextField *samplestext;
@property (nonatomic,retain) IBOutlet NSButton *startStopButton;
@property (nonatomic,retain) IBOutlet NSPopUpButton *SampleRatePopUpButton;

@end
