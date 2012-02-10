//
//  AHGraphicsCamera.m
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHScreenManager.h"
#import "AHGraphicsManager.h"
#import "AHGraphicsCamera.h"


@implementation AHGraphicsCamera


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _screenRect = [[AHScreenManager manager] screenRect];
        _aspectRatio = _screenRect.size.width / _screenRect.size.height;
        _zoom = 5.0f;
        _nearLimit = 1.0f;
        _farLimit = 15.0f;
        _centerDepth = 5.0f;
        _position = GLKVector2Make(0.0f, 0.0f);
        [self cacheWorldMatrix];
        _screenMatrix = GLKMatrix4MakeOrtho(0.0f, 
                                            _screenRect.size.width,
                                            _screenRect.size.height,
                                            0.0f,
                                            -10.0f, 
                                            10.0f);
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

- (void)prepareToDrawWorldOrtho {
    [[AHGraphicsManager manager] setCameraMatrix:_orthoMatrix];
}

- (void)prepareToDrawWorld {
    [[AHGraphicsManager manager] setCameraMatrix:_worldMatrix];
}


#pragma mark -
#pragma mark z index


- (void)setNearLimit:(float)near {
    if (near > 0.0f) {
        _nearLimit = near;
        [self cacheFrustumMatrix];
    }
}

- (void)setFarLimit:(float)far {
    if (far > 0.0f) {
        _farLimit = far;
        [self cacheFrustumMatrix];
    }
}

- (void)setCenterDepth:(float)depth {
    if (depth > 0.0f) {
        _centerDepth = depth;
        [self cacheFrustumMatrix];
    }
}


#pragma mark -
#pragma mark camera position


- (CGSize)worldSize {
    return CGSizeMake(_zoom * _aspectRatio, _zoom);
}

- (CGSize)worldSizeAt:(float)depth {
    float zoomRatio = _zoom / (depth + _nearLimit / _nearLimit);
    return CGSizeMake(zoomRatio * _aspectRatio, zoomRatio);
}

- (void)cacheFrustumMatrix {
    float zoomRatio = _zoom / (_centerDepth + _nearLimit / _nearLimit);
    _frustumMatrix = GLKMatrix4MakeFrustum(- zoomRatio * _aspectRatio, 
                                           zoomRatio * _aspectRatio, 
                                           zoomRatio, 
                                           - zoomRatio, 
                                           _nearLimit, 
                                           _farLimit);
}

- (void)cacheWorldMatrix {
    _worldMatrix = GLKMatrix4Translate(_frustumMatrix, -_position.x, -_position.y, 0.0f);
}

- (void)cacheOrthoMatrix {
    _orthoMatrix = GLKMatrix4MakeOrtho(_position.x - _zoom * _aspectRatio, 
                                       _position.x + _zoom * _aspectRatio, 
                                       _position.y + _zoom, 
                                       _position.y - _zoom, 
                                       -4.0f, 
                                       4.0f);
}

- (GLKVector2)worldPosition {
    return _position;
}

- (void)setWorldPosition:(GLKVector2)newPosition {
    _position = newPosition;
    [self cacheWorldMatrix];
    [self cacheOrthoMatrix];
}

- (float)worldZoom {
    return _zoom;
}

- (void)setWorldZoom:(float)newZoom {
    _zoom = newZoom;
    [self cacheFrustumMatrix];
    [self cacheOrthoMatrix];
}


#pragma mark -
#pragma mark conversions


- (GLKVector2)worldToScreen:(GLKVector2)worldPoint {
    // get the point that is at the center of the screen
    GLKVector2 screenCenter = GLKVector2Make([[AHScreenManager manager] screenWidth] / 2.0f, 
                                             [[AHScreenManager manager] screenHeight] / 2.0f);
    // find the distance from the initial world point to
    // the world point that is in the center of the screen
    GLKVector2 centerInWorld = GLKVector2Subtract(worldPoint, _position);
    // convert that distance from world units to screen units
    GLKVector2 centerInScreen = GLKVector2MultiplyScalar(centerInWorld, screenCenter.y / _zoom);
    // add the distance to the center of the screen to get screen coordinates
    return GLKVector2Add(centerInScreen, screenCenter);
}

- (GLKVector2)screenToWorld:(GLKVector2)screenPoint {
    // get the point that is at the center of the screen
    GLKVector2 screenCenter = GLKVector2Make([[AHScreenManager manager] screenWidth] / 2.0f, 
                                             [[AHScreenManager manager] screenHeight] / 2.0f);
    // find the distance from the center of the screen to
    // the input point in screen space
    GLKVector2 distFromCenterScreen = GLKVector2Subtract(screenCenter, screenPoint);
    // convert that distance to world space
    GLKVector2 distFromCenterWorld = GLKVector2MultiplyScalar(distFromCenterScreen, _zoom / screenCenter.y);
    // subtract the distance from the world space center
    return GLKVector2Subtract(_position, distFromCenterWorld);
}


@end
