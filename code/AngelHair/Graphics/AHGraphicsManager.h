//
//  AHGraphicsManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import <GLKit/GLKit.h>

#import "AHGraphicsVertexStruct.h"
#import "AHSubSystem.h"
#import "AHGraphicsCamera.h"


@class AHGraphicsObject;
@class AHGraphicsLayer;
@class AHShaderManager;


@interface AHGraphicsManager : NSObject <AHSubSystem> {
@private;
    NSMutableArray *_layers;
    AHGraphicsLayer *_hudLayer;
    
    EAGLContext *_eaglContext;
    
    GLKMatrix4 _currentModelViewMatrix;
    GLKMatrix4 *_modelViewPopPushStack;
    int _popPushIndex;
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


- (void)setCameraMatrix:(GLKMatrix4)matrix;
- (void)setModelMatrix:(GLKMatrix4)matrix;


#pragma mark -
#pragma mark model movement


- (void)modelIdentity;
- (void)modelPush;
- (void)modelPop;
- (void)modelMove:(GLKVector2)move;
- (void)modelMove:(GLKVector2)move 
       thenRotate:(float)rotate;
- (void)modelMove:(GLKVector2)move 
       thenRotate:(float)rotate
         thenMove:(GLKVector2)move2;
- (void)modelMove:(GLKVector2)move 
       thenRotate:(float)rotate
         thenMove:(GLKVector2)move2
       thenRotate:(float)rotate2;
- (void)modelRotate:(float)rotate;
- (void)modelRotate:(float)rotate 
           thenMove:(GLKVector2)move;
- (void)modelRotate:(float)rotate 
           thenMove:(GLKVector2)move
         thenRotate:(float)rotate2;
- (void)modelRotate:(float)rotate 
           thenMove:(GLKVector2)move
         thenRotate:(float)rotate2
           thenMove:(GLKVector2)move2;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark draw


- (void)draw;


#pragma mark -
#pragma mark layers


- (void)addLayer:(AHGraphicsLayer *)layer;
- (void)removeLayer:(AHGraphicsLayer *)layer;
- (void)removeAllUnusedLayers;
- (void)removeAllLayers;


#pragma mark -
#pragma mark layers


- (void)addObject:(AHGraphicsObject *)object toLayerIndex:(int)i;
- (void)addObjectToHudLayer:(AHGraphicsObject *)object;


#pragma mark -
#pragma mark draw array


- (void)drawPointerArrayPosition:(GLKVector3 *)position
                      andTexture:(GLKVector2 *)texture
                        andCount:(int)count 
                     andDrawType:(GLenum)type;
- (void)drawPointerArrayPosition:(GLKVector3 *)position
                        andColor:(GLKVector4)color
                        andCount:(int)count 
                     andDrawType:(GLenum)type;


@end




