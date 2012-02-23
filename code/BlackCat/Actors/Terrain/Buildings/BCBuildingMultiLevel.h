//
//  BCBuildingMultiLevel.h
//  BlackCat
//
//  Created by Tim Wood on 2/14/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "BCBuildingType.h"


@class AHPhysicsBody;


@interface BCBuildingMultiLevel : BCBuildingType


#pragma mark -
#pragma mark building


- (void)buildBackgroundAt:(float)height;
- (void)buildFloorAt:(float)height;
- (void)buildBottomAt:(float)height;
- (void)buildTopAt:(float)height;
- (void)buildWallAtBottomCenter:(GLKVector2)center;
- (void)buildWallAtBottomCenterBreakable:(GLKVector2)center;
- (float)buildingCenterPosition;
- (void)configSolidBuilding:(AHPhysicsBody *)body;


@end
