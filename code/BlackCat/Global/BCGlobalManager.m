//
//  BCGlobalManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define CAMERA_ACCELERATION 0.02f
#define CAMERA_MAX_SPEED 0.15f

#define CAMERA_ZOOM 1.0f


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
    [self updateCameraVelocityEaseOut];
    // defaults
    [[AHGraphicsManager camera] setCameraOffset:GLKVector2Make(0.0f, 0.0f)];
    [[AHGraphicsManager camera] setWorldZoom:CAMERA_ZOOM];
}

- (void)updateBeforeAnimation {
    
}

- (void)updateAfterEverything {
    
}

- (void)updateCameraVelocityEaseOut {
    float distance = idealCameraPositionY - cameraYActualPosition;
    float diff = distance / 5.0f;
    
    if (fabsf(distance) < 0.01f) {
        cameraYActualPosition = idealCameraPositionY;
    } else {
        cameraYActualPosition += diff;
    }
    
    // update camera
    //[[AHGraphicsManager camera] setWorldPosition:GLKVector2Make(idealCameraPositionX, cameraYActualPosition)];
}

- (void)updateCameraVelocity {
    float distance = idealCameraPositionY - cameraYActualPosition;
    
    if (cameraYActualPosition < idealCameraPositionY) {
        _cameraYVelocity += CAMERA_ACCELERATION;
        _cameraYVelocity = fminf(CAMERA_MAX_SPEED, distance);
    } else if (cameraYActualPosition > idealCameraPositionY) {
        _cameraYVelocity -= CAMERA_ACCELERATION;
        _cameraYVelocity = fmaxf(-CAMERA_MAX_SPEED, distance);
    } else {
        _cameraYVelocity = 0.0f;
    }
    cameraYActualPosition += _cameraYVelocity;
    
    GLKVector2 cameraPosition = GLKVector2Make(idealCameraPositionX, cameraYActualPosition);
    
    // update camera
    [[AHGraphicsManager camera] setWorldPosition:cameraPosition];
}


@end
