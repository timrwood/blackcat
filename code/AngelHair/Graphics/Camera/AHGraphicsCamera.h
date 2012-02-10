//
//  AHGraphicsCamera.h
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import <GLKit/GLKit.h>


@interface AHGraphicsCamera : NSObject {
@private;
    float _zoom;
    GLKVector2 _position;
    CGRect _screenRect;
    float _aspectRatio;
    GLKMatrix4 _orthoMatrix;
    GLKMatrix4 _screenMatrix;
    GLKMatrix4 _frustumMatrix;
    GLKMatrix4 _worldMatrix;
    
    float _nearLimit;
    float _farLimit;
    float _centerDepth;
}


#pragma mark -
#pragma mark coordinates


- (void)prepareToDrawScreen;
- (void)prepareToDrawWorldOrtho;
- (void)prepareToDrawWorld;


#pragma mark -
#pragma mark z index


- (void)setNearLimit:(float)near;
- (void)setFarLimit:(float)far;
- (void)setCenterDepth:(float)depth;


#pragma mark -
#pragma mark camera position


- (CGSize)worldSize;
- (CGSize)worldSizeAt:(float)depth;
- (void)cacheFrustumMatrix;
- (void)cacheWorldMatrix;
- (void)cacheOrthoMatrix;
- (GLKVector2)worldPosition;
- (void)setWorldPosition:(GLKVector2)newPosition;
- (float)worldZoom;
- (void)setWorldZoom:(float)newZoom;


#pragma mark -
#pragma mark conversions


- (GLKVector2)worldToScreen:(GLKVector2)worldPoint;
- (GLKVector2)screenToWorld:(GLKVector2)screenPoint;


@end
