//
//  BCGlobalManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHSuperSystem.h"
#import "BCGlobalTypes.h"


@interface BCGlobalManager : NSObject <AHSuperSystemDelegate> {
@private;
    float _cameraYVelocity;
}


#pragma mark -
#pragma mark singleton


+ (BCGlobalManager *)manager;


#pragma mark -
#pragma mark vars


@property (nonatomic) float heroSpeed;
@property (nonatomic) GLKVector2 heroPosition;
@property (nonatomic) float buildingHeightXPosition;
@property (nonatomic) float buildingHeight;
@property (nonatomic) BCHeroTypes heroType;

@property (nonatomic) float idealCameraPositionX;
@property (nonatomic) float idealCameraPositionY;
@property (nonatomic) float cameraYActualPosition;


@end
