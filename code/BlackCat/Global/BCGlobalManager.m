//
//  BCGlobalManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define CAMERA_ZOOM 8.0f


#import "AHGraphicsManager.h"
#import "BCGlobalManager.h"


static BCGlobalManager *_manager = nil;


@implementation BCGlobalManager


#pragma mark -
#pragma mark singleton


+ (BCGlobalManager *)manager {
    if (!_manager) {
        _manager = [[self alloc] init];
	}
    
	return _manager;
}


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        [self setCameraYActualPosition:0.0f];
    }
    return self;
}


#pragma mark -
#pragma mark vars


@synthesize heroSpeed;
@synthesize heroPosition;

@synthesize buildingHeightXPosition;
@synthesize buildingHeight;
@synthesize heroType;

@synthesize cameraYActualPosition;
@synthesize idealCameraPositionX;
@synthesize idealCameraPositionY;


#pragma mark -
#pragma mark update


- (void)updateBeforePhysics {
    
}

- (void)updateBeforeRender {
    if (cameraYActualPosition < idealCameraPositionY) {
        _cameraYVelocity = fminf(0.05f, idealCameraPositionY - cameraYActualPosition);
    } else if (cameraYActualPosition > idealCameraPositionY) {
        _cameraYVelocity = fmaxf(-0.05f, idealCameraPositionY - cameraYActualPosition);
    } else {
        _cameraYVelocity = 0.0f;
    }
    cameraYActualPosition += _cameraYVelocity;
    
    GLKVector2 cameraPosition = GLKVector2Make(idealCameraPositionX, cameraYActualPosition);
    
    // update camera
    [[AHGraphicsManager camera] setWorldPosition:cameraPosition];
    
    // defaults
    [[AHGraphicsManager camera] setCameraOffset:GLKVector2Make(-0.5f, 0.0f)];
    [[AHGraphicsManager camera] setWorldZoom:CAMERA_ZOOM];
}

- (void)updateBeforeAnimation {
    
}

- (void)updateAfterEverything {
}


@end
