//
//  main.m
//  LogicView
//
//  Created by Rene Hopf on 7/16/11.
//  Copyright 2011 Reroo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = NSApplicationMain(argc, (const char **)argv);
    [pool release];
    return retVal;
}
