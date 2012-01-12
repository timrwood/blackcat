//
//  AHGraphicsManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

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
        
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark vars


- (EAGLContext *)context {
    return _eaglContext;
}

- (GLKBaseEffect *)effect {
    return _baseEffect;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!_eaglContext) {
        dlog(@"Failed to create ES context");
    }
    
    [EAGLContext setCurrentContext:_eaglContext];
    
    _baseEffect = [[GLKBaseEffect alloc] init];
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
    
}


#pragma mark -
#pragma mark draw


- (void)draw {
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [_camera prepareToDrawWorld];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    [[AHPhysicsManager manager] drawDebug];
    
    //glEnableVertexAttribArray(GLKVertexAttribPosition);
    //glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, gBoxData);
    //glDrawArrays(GL_TRIANGLES, 0, 3);
    //glDisableVertexAttribArray(GLKVertexAttribPosition);
    
    /*
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, gBoxData);
	glColor4f(0.4f, 0.8f, 0.2f, 0.5f);
	glDrawArrays(GL_LINE_LOOP, 0, 4);
    */
    
    /*
    glBindVertexArrayOES(_vertexArray);
    
    // Render the object with GLKit
    [_baseEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
    
    // Render the object again with ES2
    glUseProgram(_program);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
     */
}


#pragma mark -
#pragma mark color


- (void)setDrawColor:(GLKVector4)color {
    _baseEffect.constantColor = color;
    _baseEffect.useConstantColor = YES;
    [_baseEffect prepareToDraw];
}


@end
