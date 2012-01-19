//
//  BCHeroPlaybackActor.m
//  BlackCat
//
//  Created by Tim Wood on 1/17/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHAnimationPointTrack.h"
#import "AHMathUtils.h"
#import "AHPhysicsCircle.h"
#import "AHTimeManager.h"

#import "CJSONDeserializer.h"

#import "BCGlobalManager.h"
#import "BCHeroPlaybackActor.h"


@implementation BCHeroPlaybackActor


- (id)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _body = [[AHPhysicsCircle alloc] initFromRadius:0.6f andPosition:CGPointMake(0.0f, 0.0f)];
        [_body setStatic:NO];
        [_body setSensor:YES];
        [self addComponent:_body];
        
        [self unpackData:data];
    }
    return self;
}


#pragma mark -
#pragma mark data


- (void)unpackData:(NSData *)data {
    int totalFrames = [data length] / (3 * sizeof(short));
    
    AHAnimationTimeTrack *timeTrack = [[AHAnimationTimeTrack alloc] initWithSize:totalFrames];
    _position = [[AHAnimationPointTrack alloc] initWithSize:totalFrames];
    [_position setTimeTrack:timeTrack];
    
    for (int i = 0; i < totalFrames; i++) {
        [timeTrack setTime:[self unpackFloatFromData:data atOffset:(i * 3)] atIndex:i];
        CGPoint pos = CGPointMake([self unpackFloatFromData:data atOffset:(i * 3) + 1],
                                  [self unpackFloatFromData:data atOffset:(i * 3) + 2]);
        [_position setValue:pos atIndex:i];
        /*
        dlog(@"unpacked %F %F %F", 
             [self unpackFloatFromData:data atOffset:(i * 3)],
             [self unpackFloatFromData:data atOffset:(i * 3) + 1],
             [self unpackFloatFromData:data atOffset:(i * 3) + 2]);
        */
    }
}

- (float)unpackFloatFromData:(NSData *)data atOffset:(int)offset {
    short output;
    [data getBytes:&output range:NSMakeRange(sizeof(short) * offset, sizeof(short))];
    return (float)output / 50.0f;
}
         

#pragma mark -
#pragma mark update


- (void)updateBeforeAnimation {
    float _time = [[AHTimeManager manager] worldTime];
    CGPoint pos = [_position valueAtTime:_time];
    
    dlog(@"position %F %F", pos.x, pos.y);
    
    if (_body) {
        [_body setPosition:pos];
    }
}


@end
