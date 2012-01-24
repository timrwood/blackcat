//
//  AHGraphicsManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import <GLKit/GLKit.h>
#import "AHSubSystem.h"
#import "AHGraphicsCamera.h"


@class AHGraphicsObject;
@class AHGraphicsLayer;


@interface AHGraphicsManager : NSObject <AHSubSystem> {
@private;
    NSMutableArray *_layers;
    
    EAGLContext *_eaglContext;
    GLKBaseEffect *_baseEffect;
    
    GLKVector4 _currentColor;
    
    GLuint _currentTex0;
}


#pragma mark -
#pragma mark singleton


+ (AHGraphicsManager *)manager;
+ (AHGraphicsCamera *)camera;


#pragma mark -
#pragma mark context


- (EAGLContext *)context;


#pragma mark -
#pragma mark effect


- (void)setTexture0:(GLuint)tex;
- (void)setCameraMatrix:(GLKMatrix4)matrix;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark draw


- (void)draw;


#pragma mark -
#pragma mark color


- (void)setDrawColor:(GLKVector4)color;


#pragma mark -
#pragma mark layers


- (void)addLayer:(AHGraphicsLayer *)layer atIndex:(int)i;
- (void)removeLayer:(AHGraphicsLayer *)layer;
- (void)removeAllUnusedLayers;
- (void)removeAllLayers;


#pragma mark -
#pragma mark layers


- (void)addObject:(AHGraphicsObject *)object toLayerIndex:(int)i;


@end




