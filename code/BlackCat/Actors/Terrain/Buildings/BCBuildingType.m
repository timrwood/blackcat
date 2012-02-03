//
//  BCBuildingType.m
//  BlackCat
//
//  Created by Tim Wood on 2/2/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "BCBuildingType.h"


@implementation BCBuildingType


#pragma mark -
#pragma mark heights



- (void)setStartCorner:(GLKVector2)start {
    _startCorner = start;
}

- (float)heightAtXPosition:(float)xPos {
    return _startCorner.y;
}

- (GLKVector2)endCorner {
    return GLKVector2Make(0.0f, 0.0f);
}

- (GLKVector2)startCorner {
    return _startCorner;
}


@end
