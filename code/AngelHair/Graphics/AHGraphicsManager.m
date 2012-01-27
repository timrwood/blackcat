//
//  AHGraphicsManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
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
        _baseEffect = [[GLKBaseEffect alloc] init];
        _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        _popPushStack = malloc(sizeof(GLKMatrix4) * MAX_POP_PUSH_STACK);
        _currentModelViewMatrix = GLKMatrix4Identity;
        
        if (!_eaglContext) {
            dlog(@"Failed to create EAGLContext");
        }
        
        [EAGLContext setCurrentContext:_eaglContext];
        
        _shaderManager = [[AHShaderManager alloc] init];
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


- (void)setTexture0:(GLuint)tex {
    if (tex != _currentTex0) {
        //dlog(@"Activating texture %i", tex);
        
        glPushGroupMarkerEXT(0, "Enable Texture");
        _currentTex0 = tex;
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, _currentTex0);
        /*_baseEffect.useConstantColor = NO;
        _baseEffect.texture2d0.enabled = YES;
        _baseEffect.texture2d0.envMode = GLKTextureEnvModeReplace;
        _baseEffect.texture2d0.target = GLKTextureTarget2D;
        _baseEffect.texture2d0.name = _currentTex0;
        [_baseEffect prepareToDraw];*/
        glPopGroupMarkerEXT();
         
    }
}

- (void)setCameraMatrix:(GLKMatrix4)matrix {
    //_baseEffect.transform.projectionMatrix = matrix;
    //[_baseEffect prepareToDraw];
    [_shaderManager setProjectionMatrix:matrix];
}

- (void)setModelMatrix:(GLKMatrix4)matrix {
    /*_baseEffect.transform.modelviewMatrix = matrix;
    glPushGroupMarkerEXT(0, "Set Model Matrix");
    [_baseEffect prepareToDraw];
    glPopGroupMarkerEXT();*/
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

- (void)modelPop {_popPushIndex --;
    if (_popPushIndex < 0) {
        derror(@"Model View pop is less than zero");
    }
    _currentModelViewMatrix = _popPushStack[_popPushIndex];
    //[self setModelMatrix:_popPushStack[_popPushIndex]];
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
    _baseEffect = nil;
}


#pragma mark -
#pragma mark update


- (void)update {
    for (AHGraphicsLayer *layer in _layers) {
        [layer update];
    }
}


#pragma mark -
#pragma mark draw


- (void)draw {
    glClearColor(0.65f, 0.75f, 0.85f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [_shaderManager useProgram];
    [_camera prepareToDrawWorld];
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    //glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    for (AHGraphicsLayer *layer in _layers) {
        [layer draw];
    }
}


#pragma mark -
#pragma mark color


- (void)setDrawColor:(GLKVector4)color {
    if (!GLKVector4AllEqualToVector4(color, _currentColor)) {
        _currentColor = color;
        _baseEffect.useConstantColor = YES;
        _baseEffect.texture2d0.enabled = NO;
        _baseEffect.constantColor = _currentColor;
        //[_baseEffect prepareToDraw];
    }
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
    //dlog(@"object");
    
    if (i >= [_layers count] || ![_layers objectAtIndex:i]) {
        [self addLayer:[[AHGraphicsLayer alloc] init] atIndex:i];
    }
    
    AHGraphicsLayer *layer = [_layers objectAtIndex:i];
    
    [object removeFromParentLayer];
    [layer addObject:object];
}


#pragma mark -
#pragma mark offsets


- (void)drawPointerArrayPosition:(GLKVector2 *)position
                      andTexture:(GLKVector2 *)texture
                        andCount:(int)count 
                     andDrawType:(GLenum)type {
    glVertexAttribPointer([_shaderManager vertexAttribTexCoord0], 2, GL_FLOAT, GL_FALSE, 0, texture);
    glVertexAttribPointer([_shaderManager vertexAttribPosition], 2, GL_FLOAT, GL_FALSE, 0, position);
	glDrawArrays(type, 0, count);
}

- (void)drawPointerArrayPosition:(GLKVector2 *)position
                        andColor:(GLKVector4)color
                        andCount:(int)count 
                     andDrawType:(GLenum)type {
    glVertexAttribPointer([_shaderManager vertexAttribTexCoord0], 2, GL_FLOAT, GL_FALSE, 0, position);
    glVertexAttribPointer([_shaderManager vertexAttribPosition], 2, GL_FLOAT, GL_FALSE, 0, position);
	glDrawArrays(type, 0, count);
}


@end



