//
//  AHAnimationSkeletonTrack.h
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHSkeletonStruct.h"
#import "AHAnimationTrack.h"


@interface AHAnimationSkeletonTrack : AHAnimationTrack{
@private;
    AHSkeleton *_values;
}



#pragma mark -
#pragma mark value


- (void)setValue:(AHSkeleton)value atIndex:(int)i;


#pragma mark -
#pragma mark time


- (AHSkeleton)valueAtTime:(float)frame;


@end

