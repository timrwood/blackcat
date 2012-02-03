//
//  BCBuildingType.h
//  BlackCat
//
//  Created by Tim Wood on 2/2/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActor.h"


@interface BCBuildingType : AHActor {
@protected;
    GLKVector2 _startCorner;
}


#pragma mark -
#pragma mark heights


- (void)setStartCorner:(GLKVector2)start;
- (float)heightAtXPosition:(float)xPos;
- (GLKVector2)endCorner;
- (GLKVector2)startCorner;


@end
