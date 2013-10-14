//
//  SampleRate.h
//  LogicView
//
//  Created by Rene Hopf on 10/21/12.
//  Copyright (c) 2012 Reroo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SampleRate : NSObject {
    NSString *name;
    NSString *sampleRate;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sampleRate;

- (id)initWithName:(NSString *)aName sampleRate:(NSString *)aSampleRate;

@end
