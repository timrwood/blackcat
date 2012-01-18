//
//  BCHeroRecorderActor.m
//  BlackCat
//
//  Created by Tim Wood on 1/17/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define TIME_BETWEEN_KEYFRAMES 0.1f
#define Y_DIFF_SLOP 0.0001f

#import "AHTimeManager.h"

#import "BCGlobalTypes.h"
#import "BCGlobalManager.h"
#import "BCHeroRecorderActor.h"


@implementation BCHeroRecorderActor


- (id)init {
    self = [super init];
    if (self) {
        _keyframes = [[NSMutableArray alloc] init];
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
    CGPoint position = [[BCGlobalManager manager] heroPosition];
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

- (void)recordFrameWithTime:(float)_time andPosition:(CGPoint)position {
    NSString *input = [NSString stringWithFormat:@"{\"t\":%.3F,\"x\":%.3F,\"y\":%.3F}", _time, position.x, position.y];
    [_keyframes addObject:input];
}


#pragma mark -
#pragma mark output


- (NSData *)outputData {
    float time = [[AHTimeManager manager] worldTime];
    float count = [_keyframes count];
    dlog(@"time : %.2F   frames : %i   FPS : %.2f", time, (int) count, count / time);
    return [[self outputString] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)outputString {
    NSMutableString *output = [NSMutableString stringWithString:@"["];
    BOOL pastFirst = NO;
    for (NSString *string in _keyframes) {
        if (pastFirst) {
            [output appendString:@","];
        }
        [output appendString:string];
        pastFirst = YES;
    }
    [output appendString:@"]"];
    return output;
}


@end
