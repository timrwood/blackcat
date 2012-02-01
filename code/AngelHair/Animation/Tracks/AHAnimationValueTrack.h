//
//  AHAnimationTrack.h
//  BlackCat
//
//  Created by Tim Wood on 1/18/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHAnimationTrack.h"


@interface AHAnimationValueTrack : AHAnimationTrack {
@private;
    float *_values;
}


#pragma mark -
#pragma mark value


- (void)setValuesFromArray:(NSArray *)values;
- (void)setValue:(float)value atIndex:(int)i;


#pragma mark -
#pragma mark time


- (float)valueAtTime:(float)frame;


@end
