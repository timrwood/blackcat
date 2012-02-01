//
//  BCBuildingActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHActor.h"


@class AHPhysicsRect;
@class AHGraphicsRect;


@interface BCBuildingActor : AHActor {
@private;
    AHGraphicsRect *_skin;
    AHPhysicsRect *_body;
    float _distanceCoveredRight;
    float _distanceCoveredLeft;
    float _height;
    
    float _spacing;
    float _prevHeight;
}


#pragma mark -
#pragma mark init


- (id)initFromSize:(CGSize)size andPosition:(GLKVector2)position;


#pragma mark -
#pragma mark coverage


- (void)setPrevHeight:(float)prevHeight;
- (void)setSpacing:(float)spacing;
- (float)distanceCovered;
- (float)height;
- (float)heightAtPosition:(float)position;


@end
