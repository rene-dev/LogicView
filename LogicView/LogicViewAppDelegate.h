//
//  LogicViewAppDelegate.h
//  LogicView
//
//  Created by Rene Hopf on 7/16/11.
//  Copyright 2011 Reroo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SaleaeLogic.h"

@interface LogicViewAppDelegate : NSObject <NSApplicationDelegate,SaleaeLogicConnectionDelegate> {
    NSWindow *_window;
    SaleaeLogic *sLogic;
    IBOutlet NSButton *startStopButton;
    IBOutlet NSTextField *connected;
    IBOutlet NSTextField *value;
}
- (IBAction)botton:(id)sender;

@property (strong) IBOutlet NSWindow *window;
@property (nonatomic,retain) IBOutlet NSTextField *value;
@property (nonatomic,retain) IBOutlet NSButton *startStopButton;
@property (nonatomic,retain) IBOutlet NSTextField *connected;


@end
