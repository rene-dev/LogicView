//
//  LogicViewAppDelegate.h
//  LogicView
//
//  Created by Rene Hopf on 7/16/11.
//  Copyright 2011 Reroo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SaleaeLogic.h"

@interface LogicViewAppDelegate : NSObject <NSApplicationDelegate,SaleaeLogicDelegate> {
    NSWindow *_window;
    SaleaeLogic *sLogic;
    IBOutlet NSButton *startStopButton;
    IBOutlet NSTextField *value;
    IBOutlet NSTextField *samplestext;
    int samples;
    IBOutlet NSPopUpButton *sampleRate;
    IBOutlet NSTextField *textField;
}
- (IBAction)botton:(id)sender;
- (void)sampleRateChanged:(id)sender;
- (void)displayError;

@property (strong) IBOutlet NSWindow *window;
@property (nonatomic,retain) IBOutlet NSTextField *value;
@property (nonatomic,retain) IBOutlet NSTextField *samplestext;
@property (nonatomic,retain) IBOutlet NSButton *startStopButton;
@property (nonatomic,retain) IBOutlet NSPopUpButton *SampleRatePopUpButton;
@property (nonatomic,retain) IBOutlet NSTextField *textField;

@end
