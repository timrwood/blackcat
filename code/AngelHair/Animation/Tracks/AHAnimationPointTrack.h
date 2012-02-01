//
//  AHAnimationPointTrack.h
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHAnimationTrack.h"


@interface AHAnimationPointTrack : AHAnimationTrack {
@private;
    GLKVector2 *_values;
}



#pragma mark -
#pragma mark value


- (void)setValuesFromArray:(NSArray *)values;
- (void)setValue:(GLKVector2)value atIndex:(int)i;


#pragma mark -
#pragma mark time


- (GLKVector2)valueAtTime:(float)frame;


@end
