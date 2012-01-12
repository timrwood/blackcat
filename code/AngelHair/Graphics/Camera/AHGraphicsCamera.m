//
//  AHGraphicsCamera.m
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsManager.h"
#import "AHGraphicsCamera.h"


@implementation AHGraphicsCamera


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _screenRect = [[UIScreen mainScreen] bounds];
        _aspectRatio = _screenRect.size.height / _screenRect.size.width;
        _zoom = 5.0f;
        _position = GLKVector2Make(0.0f, 0.0f);
        [self cacheWorldMatrix];
        _screenMatrix = GLKMatrix4MakeOrtho(0.0f, 
                                            _screenRect.size.width, 
                                            0.0f, 
                                            _screenRect.size.height, 
                                            -1.0f, 
                                            1.0f);
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark coordinates


- (void)prepareToDrawScreen {
    [[AHGraphicsManager manager] effect].transform.projectionMatrix = _screenMatrix;
    [[[AHGraphicsManager manager] effect] prepareToDraw];
}

- (void)prepareToDrawWorld {
    [[AHGraphicsManager manager] effect].transform.projectionMatrix = _worldMatrix;
    [[[AHGraphicsManager manager] effect] prepareToDraw];
}


#pragma mark -
#pragma mark camera position


- (CGPoint)worldPosition {
    return CGPointMake(_position.x, _position.y);
}

- (float)worldZoom {
    return _zoom;
}

- (void)cacheWorldMatrix {
    _worldMatrix = GLKMatrix4MakeOrtho(_position.x - _zoom * _aspectRatio, 
                                       _position.x + _zoom * _aspectRatio, 
                                       _position.y - _zoom, 
                                       _position.y + _zoom, 
                                       -1.0f, 
                                       1.0f);
}

- (void)setWorldPosition:(CGPoint)newPosition {
    _position.x = newPosition.x;
    _position.y = newPosition.y;
    [self cacheWorldMatrix];
}

- (void)setWorldZoom:(float)newZoom {
    _zoom = newZoom;
    [self cacheWorldMatrix];
}


#pragma mark -
#pragma mark conversions


- (CGPoint)worldToScreen:(CGPoint)worldPoint {
    
}

- (CGPoint)screenToWorld:(CGPoint)screenPoint {
    
}


@end
