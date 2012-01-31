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
                                            _screenRect.size.height, 
                                            0.0f, 
                                            _screenRect.size.width, 
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
    [[AHGraphicsManager manager] setCameraMatrix:_screenMatrix];
}

- (void)prepareToDrawWorld {
    [[AHGraphicsManager manager] setCameraMatrix:_worldMatrix];
}


#pragma mark -
#pragma mark camera position


- (CGSize)worldSize {
    return CGSizeMake(_zoom * _aspectRatio, _zoom);
}

- (void)cacheWorldMatrix {
    _worldMatrix = GLKMatrix4MakeOrtho(_position.x - _zoom * _aspectRatio, 
                                       _position.x + _zoom * _aspectRatio, 
                                       _position.y + _zoom, 
                                       _position.y - _zoom, 
                                       -1.0f, 
                                       1.0f);
}

- (GLKVector2)worldPosition {
    return _position;
}

- (void)setWorldPosition:(GLKVector2)newPosition {
    _position = newPosition;
    [self cacheWorldMatrix];
}

- (float)worldZoom {
    return _zoom;
}

- (void)setWorldZoom:(float)newZoom {
    _zoom = newZoom;
    [self cacheWorldMatrix];
}


#pragma mark -
#pragma mark conversions


- (GLKVector2)worldToScreen:(GLKVector2)worldPoint {
    
}

- (GLKVector2)screenToWorld:(GLKVector2)screenPoint {
    
}


@end
