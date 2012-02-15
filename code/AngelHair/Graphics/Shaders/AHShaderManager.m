//
//  AHShaderManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/25/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHShaderManager.h"


static AHShaderManager *_manager = nil;


@implementation AHShaderManager


#pragma mark -
#pragma mark singleton


+ (AHShaderManager *)manager {
	if (!_manager) {
        _manager = [[self alloc] init];
	}
    
	return _manager;
}

#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _colorShader = [[AHShaderColor alloc] init];
        _textureShader = [[AHShaderTexture alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    
}


#pragma mark -
#pragma mark program


- (void)useTextureProgram {
    if (_currentShader != _textureShader) {
        [_textureShader activate];
        [_colorShader deactivate];
        _currentShader = _textureShader;
    }
}

- (void)useColorProgram {
    if (_currentShader != _colorShader) {
        [_colorShader activate];
        [_colorShader deactivate];
        _currentShader = _colorShader;
    }
}


#pragma mark -
#pragma mark color


- (void)setColor:(GLKVector4)color {
    [_colorShader setColor:color];
}


#pragma mark -
#pragma mark matrixes


- (void)setModelViewMatrix:(GLKMatrix4)matrix {
    [_colorShader setModelView:matrix];
    [_textureShader setModelView:matrix];
}

- (void)setProjectionMatrix:(GLKMatrix4)matrix {
    [_colorShader setProjection:matrix];
    [_textureShader setProjection:matrix];
}


#pragma mark -
#pragma mark debug


- (void)debug {
    GLenum error = glGetError();
    if (error != GL_NO_ERROR) {
        NSString *errorCode;
        switch (error) {
            case GL_INVALID_ENUM:
                errorCode = @"GL_INVALID_ENUM";
                break;
            case GL_INVALID_VALUE:
                errorCode = @"GL_INVALID_VALUE";
                break;
            case GL_INVALID_OPERATION:
                errorCode = @"GL_INVALID_OPERATION";
                break;
            case GL_OUT_OF_MEMORY:
                errorCode = @"GL_OUT_OF_MEMORY";
                break;
            default:
                errorCode = @"UNKNOWN_ERROR_CODE";
                break;
        }
        dlog(@"OpenGL Error (%i) %@", error, errorCode);
        [self debug];
        //exit(1);
    }
}


@end
