//
//  AHTimeManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/17/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHSubSystem.h"


@interface AHTimeManager : NSObject <AHSubSystem> {
@private;
    float _worldTime;
    float _realTime;
    float _ratio;
    float _framesPerSecond;
}


#pragma mark -
#pragma mark singleton


+ (AHTimeManager *)manager;


#pragma mark -
#pragma mark reset


- (void)reset;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark time


- (float)worldTime;
- (float)realTime;
- (void)setWorldToRealRatio:(float)ratio;
- (void)setFramesPerSecond:(float)framesPerSecond;
- (float)realFramesPerSecond;
- (float)realSecondsPerFrame;
- (float)worldFramesPerSecond;
- (float)worldSecondsPerFrame;


@end
