//
//  AHAnimationPointTrack.h
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHAnimationTrack.h"


@interface AHAnimationPointTrack : AHAnimationTrack {
@private;
    CGPoint *_values;
}



#pragma mark -
#pragma mark value


- (void)setValuesFromArray:(NSArray *)values;
- (void)setValue:(CGPoint)value atIndex:(int)i;


#pragma mark -
#pragma mark time


- (CGPoint)valueAtTime:(float)frame;


@end
