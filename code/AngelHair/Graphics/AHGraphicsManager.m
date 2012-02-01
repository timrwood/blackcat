//
//  AHGraphicsManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define MAX_POP_PUSH_STACK 8


#import "AHShaderManager.h"
#import "AHGraphicsObject.h"
#import "AHGraphicsLayer.h"
#import "AHGraphicsManager.h"
#import "AHPhysicsManager.h"


static AHGraphicsManager *_manager = nil;
static AHGraphicsCamera *_camera = nil;


@implementation AHGraphicsManager


#pragma mark -
#pragma mark singleton


+ (AHGraphicsManager *)manager {
	if (!_manager) {
        _manager = [[self alloc] init];
	}
    if (!_camera) {
        _camera = [[AHGraphicsCamera alloc] init];
	}
    
	return _manager;
}

+ (AHGraphicsCamera *)camera {
    if (!_camera) {
        _camera = [[AHGraphicsCamera alloc] init];
	}
    
    return _camera;
}


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _layers = [[NSMutableArray alloc] init];
        _hudLayer = [[AHGraphicsLayer alloc] init];
        _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        _popPushStack = malloc(sizeof(GLKMatrix4) * MAX_POP_PUSH_STACK);
        _currentModelViewMatrix = GLKMatrix4Identity;
        
        if (!_eaglContext) {
            dlog(@"Failed to create EAGLContext");
        }
        
        [EAGLContext setCurrentContext:_eaglContext];
        
        _shaderManager = [[AHShaderManager alloc] init];
        [self modelIdentity];
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark context


- (EAGLContext *)context {
    return _eaglContext;
}


#pragma mark -
#pragma mark effect


- (void)setCameraMatrix:(GLKMatrix4)matrix {
    [_shaderManager setProjectionMatrix:matrix];
}

- (void)setModelMatrix:(GLKMatrix4)matrix {
    _currentModelViewMatrix = matrix;
    [_shaderManager setModelViewMatrix:matrix];
}


#pragma mark -
#pragma mark model movement


- (void)modelIdentity {
    [self setModelMatrix:GLKMatrix4Identity];
}

- (void)modelPush {
    _popPushStack[_popPushIndex] = _currentModelViewMatrix;
    _popPushIndex ++;
    if (_popPushIndex >= MAX_POP_PUSH_STACK) {
        derror(@"Model View push is greater than the max");
    }
}

- (void)modelPop {
    _popPushIndex --;
    if (_popPushIndex < 0) {
        derror(@"Model View pop is less than zero");
    }
    [self setModelMatrix:_popPushStack[_popPushIndex]];
}

- (void)modelMove:(GLKVector2)move {
    GLKMatrix4 matrix = _currentModelViewMatrix;
    matrix = GLKMatrix4Translate(matrix, move.x, move.y, 0.0f);
    [self setModelMatrix:matrix];
}

- (void)modelMove:(GLKVector2)move 
       thenRotate:(float)rotate {
    GLKMatrix4 matrix = _currentModelViewMatrix;
    matrix = GLKMatrix4Translate(matrix, move.x, move.y, 0.0f);
    matrix = GLKMatrix4RotateZ(matrix, rotate);
    [self setModelMatrix:matrix];
}

- (void)modelMove:(GLKVector2)move 
       thenRotate:(float)rotate
         thenMove:(GLKVector2)move2 {
    GLKMatrix4 matrix = _currentModelViewMatrix;
    matrix = GLKMatrix4Translate(matrix, move.x, move.y, 0.0f);
    matrix = GLKMatrix4RotateZ(matrix, rotate);
    matrix = GLKMatrix4Translate(matrix, move2.x, move2.y, 0.0f);
    [self setModelMatrix:matrix];
}

- (void)modelMove:(GLKVector2)move 
       thenRotate:(float)rotate
         thenMove:(GLKVector2)move2
       thenRotate:(float)rotate2 {
    GLKMatrix4 matrix = _currentModelViewMatrix;
    matrix = GLKMatrix4Translate(matrix, move.x, move.y, 0.0f);
    matrix = GLKMatrix4RotateZ(matrix, rotate);
    matrix = GLKMatrix4Translate(matrix, move2.x, move2.y, 0.0f);
    matrix = GLKMatrix4RotateZ(matrix, rotate2);
    [self setModelMatrix:matrix];
}

- (void)modelRotate:(float)rotate {
    GLKMatrix4 matrix = _currentModelViewMatrix;
    matrix = GLKMatrix4RotateZ(matrix, rotate);
    [self setModelMatrix:matrix];
}

- (void)modelRotate:(float)rotate 
           thenMove:(GLKVector2)move {
    GLKMatrix4 matrix = _currentModelViewMatrix;
    matrix = GLKMatrix4RotateZ(matrix, rotate);
    matrix = GLKMatrix4Translate(matrix, move.x, move.y, 0.0f);
    [self setModelMatrix:matrix];
}

- (void)modelRotate:(float)rotate 
           thenMove:(GLKVector2)move
         thenRotate:(float)rotate2 {
    GLKMatrix4 matrix = _currentModelViewMatrix;
    matrix = GLKMatrix4RotateZ(matrix, rotate);
    matrix = GLKMatrix4Translate(matrix, move.x, move.y, 0.0f);
    matrix = GLKMatrix4RotateZ(matrix, rotate2);
    [self setModelMatrix:matrix];
}

- (void)modelRotate:(float)rotate 
           thenMove:(GLKVector2)move
         thenRotate:(float)rotate2
           thenMove:(GLKVector2)move2 {
    GLKMatrix4 matrix = _currentModelViewMatrix;
    matrix = GLKMatrix4RotateZ(matrix, rotate);
    matrix = GLKMatrix4Translate(matrix, move.x, move.y, 0.0f);
    matrix = GLKMatrix4RotateZ(matrix, rotate2);
    matrix = GLKMatrix4Translate(matrix, move2.x, move2.y, 0.0f);
    [self setModelMatrix:matrix];
}


#pragma mark -
#pragma mark setup


- (void)setup {
    
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    [EAGLContext setCurrentContext:_eaglContext];
}


#pragma mark -
#pragma mark update


- (void)update {
    for (AHGraphicsLayer *layer in _layers) {
        [layer update];
    }
    [_hudLayer update];
}


#pragma mark -
#pragma mark draw


- (void)draw {
    [_camera prepareToDrawWorld];
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    for (AHGraphicsLayer *layer in _layers) {
        [layer draw];
    }
    
    [_camera prepareToDrawScreen];
    [_hudLayer draw];
}


#pragma mark -
#pragma mark layers


- (void)addLayer:(AHGraphicsLayer *)layer atIndex:(int)i {
    if (![_layers containsObject:layer]) {
        [_layers addObject:layer];
    }
}

- (void)removeLayer:(AHGraphicsLayer *)layer {
    if ([_layers containsObject:layer]) {
        [_layers removeObject:layer];
    }
}

- (void)removeAllUnusedLayers {
    int skipped = 0;
    while ([_layers count] > skipped) {
        AHGraphicsLayer *layer = (AHGraphicsLayer *)[_layers objectAtIndex:skipped];
        if ([layer hasObjects]) {
            skipped ++;
        } else {
            [self removeLayer:layer];
        }
    }
}

- (void)removeAllLayers {
    while ([_layers count] > 0) {
        [self removeLayer:(AHGraphicsLayer *)[_layers objectAtIndex:0]];
    }
}


#pragma mark -
#pragma mark layers


- (void)addObject:(AHGraphicsObject *)object toLayerIndex:(int)i {
    if (i >= [_layers count] || ![_layers objectAtIndex:i]) {
        [self addLayer:[[AHGraphicsLayer alloc] init] atIndex:i];
    }
    
    AHGraphicsLayer *layer = [_layers objectAtIndex:i];
    
    [object removeFromParentLayer];
    [layer addObject:object];
}

- (void)addObjectToHudLayer:(AHGraphicsObject *)object {
    [object removeFromParentLayer];
    [_hudLayer addObject:object];
}


#pragma mark -
#pragma mark offsets


- (void)drawPointerArrayPosition:(GLKVector2 *)position
                      andTexture:(GLKVector2 *)texture
                        andCount:(int)count 
                     andDrawType:(GLenum)type {
    glVertexAttribPointer(AH_SHADER_ATTRIB_TEX_COORD, 2, GL_FLOAT, GL_FALSE, 0, texture);
    glVertexAttribPointer(AH_SHADER_ATTRIB_POS_COORD, 2, GL_FLOAT, GL_FALSE, 0, position);
	glDrawArrays(type, 0, count);
}

- (void)drawPointerArrayPosition:(GLKVector2 *)position
                        andColor:(GLKVector4)color
                        andCount:(int)count 
                     andDrawType:(GLenum)type {
    [_shaderManager setColor:color];
    glVertexAttribPointer(AH_SHADER_ATTRIB_POS_COORD, 2, GL_FLOAT, GL_FALSE, 0, position);
	glDrawArrays(type, 0, count);
}


#pragma mark -
#pragma mark color texture


- (void)useTextureProgram:(BOOL)useTex {
    if (useTex) {
        [_shaderManager useTextureProgram];
    } else {
        [_shaderManager useColorProgram];
    }
}


@end



