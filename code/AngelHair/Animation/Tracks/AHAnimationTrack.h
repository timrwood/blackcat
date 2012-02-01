//
//  AHAnimationTrack.h
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHAnimationTimeTrack.h"


@interface AHAnimationTrack : NSObject {
@protected;
    int size;
@private;
    AHAnimationTimeTrack *_timeTrack;
    
    float _lastTime;
    int _lastIndexA;
    float _lastPercent;
}


#pragma mark -
#pragma mark init


- (id)initWithSize:(int)newSize;


#pragma mark -
#pragma mark time


- (void)setTimeTrack:(AHAnimationTimeTrack *)timeTrack;
- (int)indexAAtTime:(float)time;
- (int)indexBAtTime:(float)time;
- (float)percentAtTime:(float)time;


@end
