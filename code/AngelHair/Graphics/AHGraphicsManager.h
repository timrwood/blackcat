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
@class AHShaderManager;


@interface AHGraphicsManager : NSObject <AHSubSystem> {
@private;
    NSMutableArray *_layers;
    
    EAGLContext *_eaglContext;
    
    AHShaderManager *_shaderManager;
    
    GLKBaseEffect *_baseEffect;
    
    GLKMatrix4 _currentModelViewMatrix;
    GLKMatrix4 _currentProjectionMatrix;
    GLKMatrix4 *_popPushStack;
    int _popPushIndex;
    
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


#pragma mark -
#pragma mark draw array


- (void)drawPointerArrayPosition:(GLKVector2 *)position
                      andTexture:(GLKVector2 *)texture
                        andCount:(int)count 
                     andDrawType:(GLenum)type;
- (void)drawPointerArrayPosition:(GLKVector2 *)position
                        andColor:(GLKVector4)color
                        andCount:(int)count 
                     andDrawType:(GLenum)type;


#pragma mark -
#pragma mark color texture


- (void)useTextureProgram:(BOOL)useTex;


@end




