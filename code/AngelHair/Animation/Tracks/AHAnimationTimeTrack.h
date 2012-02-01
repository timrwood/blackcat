//
//  AHAnimationTimeTrack.h
//  BlackCat
//
//  Created by Tim Wood on 1/18/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


@interface AHAnimationTimeTrack : NSObject {
@private;
    float *_times;
    int _size;
    
    BOOL _isLooped;
    
    float _length;
}


#pragma mark -
#pragma mark init


- (id)initWithSize:(int)size;


#pragma mark -
#pragma mark times


- (void)setTimesFromArray:(NSArray *)times;
- (void)setTime:(float)_time atIndex:(int)i;
- (float)indexAtTime:(float)frame;


#pragma mark -
#pragma mark looped


- (void)setLoopedLength:(float)length;


@end
