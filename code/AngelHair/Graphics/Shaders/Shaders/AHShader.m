//
//  AHShader.m
//  BlackCat
//
//  Created by Tim Wood on 2/15/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHShaderManager.h"
#import "AHShader.h"


@implementation AHShader


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _programId = glCreateProgram();
        _lightPositionUniform = -1;
        [self compile];
    }
    return self;
}


#pragma mark -
#pragma mark compile shaders


- (GLuint)compileShader:(NSString *)shaderName withExtension:(NSString *)ext withType:(GLenum)shaderType {
    // load shader from bundle
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName 
                                                           ofType:ext];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath 
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // create a handle
    GLuint shaderHandle = glCreateShader(shaderType);    
    
    // compile shader source
    const char * shaderStringUTF8 = [shaderString UTF8String];    
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // compile shader
    glCompileShader(shaderHandle);
    
    // check for success
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        dlog(@"Error compiling %@ %@", shaderName, messageString);
        exit(1);
    }
    
    return shaderHandle;
}

- (void)compile {
    
}


#pragma mark -
#pragma mark uniforms


- (void)setLightPositionUniform:(GLuint)uniform {
    _lightPositionUniform = uniform;
    dlog(@"_lightPositionUniform %i", _lightPositionUniform);
}

- (void)setLightPosition:(GLKVector3)position {
    _lightPosition = position;
    if (_isActive && _lightPositionUniform > -1) {
        glUniform3fv(_lightPositionUniform, 1, _lightPosition.v);
    }
}

- (void)setProjectionUniform:(GLuint)uniform {
    _projectionUniform = uniform;
}

- (void)setModelViewUniform:(GLuint)uniform {
    _modelViewUniform = uniform;
}

- (void)setProjection:(GLKMatrix4)matrix {
    _projectionMatrix = matrix;
    if (_isActive) {
        glUniformMatrix4fv(_projectionUniform, 1, 0, matrix.m);
    }
}

- (void)setNormal:(GLKMatrix4)matrix {
    
}

- (void)setModelView:(GLKMatrix4)matrix {
    _modelViewMatrix = matrix;
    if (_isActive) {
        glUniformMatrix4fv(_modelViewUniform, 1, 0, matrix.m);
    }
}


#pragma mark -
#pragma mark activate


- (GLuint)programId {
    return _programId;
}

- (void)activate {
    _isActive = YES;
    glUseProgram(_programId);
    glUniformMatrix4fv(_modelViewUniform, 1, 0, _modelViewMatrix.m);
    glUniformMatrix4fv(_projectionUniform, 1, 0, _projectionMatrix.m);
    if (_lightPositionUniform > -1) {
        glUniform3f(_lightPositionUniform, _lightPosition.x, _lightPosition.y, _lightPosition.z);
    }
}

- (void)deactivate {
    _isActive = NO;
}

- (BOOL)isActive {
    return _isActive;
}


@end
