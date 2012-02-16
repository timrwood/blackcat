//
//  BCBuildingSplitter.h
//  BlackCat
//
//  Created by Tim Wood on 2/7/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

#import "AHGraphicsCube.h"
#import "BCBuildingType.h"


@class AHPhysicsRect;
@class AHPhysicsPolygon;


@interface BCBuildingSplitter : BCBuildingType {
@private;
    AHPhysicsPolygon *_stairCeiling;
    AHPhysicsPolygon *_step1;
    AHPhysicsRect *_step2;
    
    AHGraphicsCube *_skinGroundTop;
    AHGraphicsCube *_skinGroundBot;
    AHGraphicsCube *_skinStairTop;
    AHGraphicsCube *_skinStairAngled;
    AHGraphicsCube *_skinStairBotCeil;
    AHGraphicsCube *_skinStairBotBack;
    AHGraphicsCube *_skinStairBotFront;
}


#pragma mark -
#pragma mark setup


- (void)setupStep1;
- (void)setupStep2;
- (void)setupStairCeiling;
- (void)setupStairCeilingMiddle;
- (void)setupStairCeilingEnd;


@end
