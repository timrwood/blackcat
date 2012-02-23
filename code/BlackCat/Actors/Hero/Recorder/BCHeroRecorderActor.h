//
//  BCHeroRecorderActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/17/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHActor.h"


@interface BCHeroRecorderActor : AHActor {
@private;
    NSMutableData *_data;
    float _timeSinceLastKeyframe;
    
    GLKVector2 _lastPosition;
    float _lastTime;
    
    BOOL _skippedLastFrame;
    
    float _debugLastX;
}


#pragma mark -
#pragma mark update


- (void)updateFrame;
- (void)recordFrameIfDifferent;
- (void)forceRecordFrame;
- (void)recordFrameWithTime:(float)_time andPosition:(GLKVector2)position;


#pragma mark -
#pragma mark output


- (NSData *)outputData;


@end
