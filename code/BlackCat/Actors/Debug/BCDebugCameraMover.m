//
//  BCDebugCameraMover.m
//  BlackCat
//
//  Created by Tim Wood on 2/17/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHLightManager.h"
#import "AHGraphicsManager.h"
#import "AHScreenManager.h"

#import "BCGlobalTypes.h"
#import "BCDebugCameraMover.h"


@implementation BCDebugCameraMover


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        // input
        _input = [[AHInputComponent alloc] initWithScreenRect:[[AHScreenManager manager] screenRect]];
        [_input setDelegate:self];
        [self addComponent:_input];
    }
    return self;
}


#pragma mark -
#pragma mark camera


- (void)touchBegan {
    _moved = GLKVector2Make(0.0f, 0.0f);
}

- (void)touchMoved:(GLKVector2)point {
    GLKVector2 camera = [[AHGraphicsManager camera] worldPosition];
    GLKVector2 diff = GLKVector2Subtract(_moved, point);
    camera = GLKVector2Add(camera, GLKVector2DivideScalar(diff, 100.0f));
    GLKVector3 light = GLKVector3Make(camera.x, camera.y, Z_LIGHT);
    
    [[AHLightManager manager] setPosition:light];
    [[AHGraphicsManager camera] setWorldPosition:camera];
    _moved = point;
}


@end
