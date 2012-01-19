//
//  AHAnimationTrack.h
//  BlackCat
//
//  Created by Tim Wood on 1/18/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHAnimationTimeTrack.h"


@interface AHAnimationValueTrack : NSObject {
@private;
    int _size;
    AHAnimationTimeTrack *_timeTrack;
    float *_values;
    float _length;
    
    BOOL _isLooped;
}


#pragma mark -
#pragma mark init


- (id)initWithSize:(int)size;


#pragma mark -
#pragma mark value


- (void)setValuesFromArray:(NSArray *)values;
- (void)setValue:(float)value atIndex:(int)i;


#pragma mark -
#pragma mark time


- (void)setTimeTrack:(AHAnimationTimeTrack *)timeTrack;
- (float)valueAtTime:(float)frame;


@end
