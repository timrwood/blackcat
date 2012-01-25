//
//  AHShaderManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/25/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHShaderManager.h"


@implementation AHShaderManager


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        [self compileShaders];
    }
    return self;
}


#pragma mark -
#pragma mark compile


- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    // load shader from bundle
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName 
                                                           ofType:@"glsl"];
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
        dlog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
}

- (void)compileShaders {
    // load shaders
    GLuint vertexShader = [self compileShader:@"AHShaderSimpleVertex" 
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"AHShaderSimpleFragment" 
                                       withType:GL_FRAGMENT_SHADER];
    
    // create program
    _programHandle = glCreateProgram();
    glAttachShader(_programHandle, vertexShader);
    glAttachShader(_programHandle, fragmentShader);
    glLinkProgram(_programHandle);
    
    // check for success
    GLint linkSuccess;
    glGetProgramiv(_programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(_programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        dlog(@"%@", messageString);
        exit(1);
    }
    
    // use program
    glUseProgram(_programHandle);
    
    // assign pointers for position and color
    _positionSlot = glGetAttribLocation(_programHandle, "position");
    _colorSlot = glGetAttribLocation(_programHandle, "sourceColor");
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    
    // assign pointers for
    _modelViewUniform = glGetUniformLocation(_programHandle, "modelview");
    _projectionUniform = glGetUniformLocation(_programHandle, "projection");
    
    dlog(@"_projectionUniform = %i", _projectionUniform);
    dlog(@"_modelViewUniform = %i", _modelViewUniform);
    
    dlog(@"Compiled Shaders");
}


#pragma mark -
#pragma mark program


- (void)useProgram {
    glUseProgram(_programHandle);
    [self debug];
}


#pragma mark -
#pragma mark matrixes


- (void)setModelViewMatrix:(GLKMatrix4)matrix {
    glUniformMatrix4fv(_modelViewUniform, 1, 0, matrix.m);
    [self debug];
}

- (void)setProjectionMatrix:(GLKMatrix4)matrix {
    glUniformMatrix4fv(_projectionUniform, 1, 0, matrix.m);
    [self debug];
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


#pragma mark -
#pragma mark offsets


- (GLuint)vertexAttribTexCoord0 {
    return 0;
}

- (GLuint)vertexAttribPosition {
    return _positionSlot;
}


@end
