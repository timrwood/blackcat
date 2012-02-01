//
//  BCHeroRecorderActor.m
//  BlackCat
//
//  Created by Tim Wood on 1/17/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define TIME_BETWEEN_KEYFRAMES 0.15f
#define Y_DIFF_SLOP 0.001f


#import "AHTimeManager.h"

#import "BCGlobalTypes.h"
#import "BCGlobalManager.h"
#import "BCHeroRecorderActor.h"


@implementation BCHeroRecorderActor


- (id)init {
    self = [super init];
    if (self) {
        _data = [[NSMutableData alloc] init];
    }
    return self;
}


#pragma mark - 
#pragma mark setup


- (void)setup {
    [super setup];
    [self forceRecordFrame];
}


#pragma mark -
#pragma mark update


- (void)updateBeforeAnimation {
    [self updateFrame];
}

- (void)updateFrame {
    if (_timeSinceLastKeyframe > TIME_BETWEEN_KEYFRAMES) {
        [self recordFrameIfDifferent];
        
        _timeSinceLastKeyframe = 0.0f;
    }
    _timeSinceLastKeyframe += [[AHTimeManager manager] worldSecondsPerFrame];
}

- (void)recordFrameIfDifferent {
    GLKVector2 position = [[BCGlobalManager manager] heroPosition];
    if (fabsf(_lastPosition.y - position.y) > Y_DIFF_SLOP) {
        if (_skippedLastFrame) {
            [self recordFrameWithTime:_lastTime andPosition:_lastPosition];
        }
        [self forceRecordFrame];
        _skippedLastFrame = NO;
    } else {
        _skippedLastFrame = YES;
    }
    _lastPosition = position;
    _lastTime = [[AHTimeManager manager] worldTime];
}

- (void)forceRecordFrame {
    [self recordFrameWithTime:[[AHTimeManager manager] worldTime] andPosition:[[BCGlobalManager manager] heroPosition]];
}

- (void)recordFrameWithTime:(float)_time andPosition:(GLKVector2)position {
    short t = _time * 50;
    short x = position.x * 50;
    short y = position.y * 50;
    
    [_data appendBytes:&t length:sizeof(short)];
    [_data appendBytes:&x length:sizeof(short)];
    [_data appendBytes:&y length:sizeof(short)];
    
    // debug
    _debugLastX = position.x;
}


#pragma mark -
#pragma mark output


- (NSData *)outputData {
    /*
    float time = [[AHTimeManager manager] worldTime];
    float count = [_data length] / (3.0f * sizeof(short));
    dlog(@"time : %.2F   frames : %i   FPS : %.2f", time, (int) count, count / time);
    dlog(@"time : %.2F   size : %i   SPS : %.2f", time, (int) [_data length], [_data length] / time);
    dlog(@"estimated minutes to overflow : %F", (4096 / ([_data length] / time)) / 60.0f);
    dlog(@"last x value %F", _debugLastX);
    */
    return _data;
}


@end
