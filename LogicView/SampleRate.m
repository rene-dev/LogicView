//
//  SampleRate.m
//  LogicView
//
//  Created by Rene Hopf on 10/21/12.
//  Copyright (c) 2012 Reroo. All rights reserved.
//

#import "SampleRate.h"

@implementation SampleRate
@synthesize name,sampleRate;

- (id)initWithName:(NSString *)aName sampleRate:(NSString *)aSampleRate {
    if (![super init]) {
        return nil; // Bail!
    }
    
    name = aName;
    sampleRate = aSampleRate;
    
    return self;
}

@end
