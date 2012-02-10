//
//  AHShaderManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/25/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHShaderManager.h"


@implementation AHShaderManager


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _textureUniforms = malloc(sizeof(GLuint) * AH_SHADER_UNIFORM_COUNT);
        _colorUniforms = malloc(sizeof(GLuint) * AH_SHADER_UNIFORM_COUNT);
        _currentUniforms = malloc(sizeof(GLuint) * AH_SHADER_UNIFORM_COUNT);
        [self compileTextureShaders];
        [self compileColorShaders];
        [self useTextureProgram];
    }
    return self;
}

- (void)dealloc {
    if (_textureUniforms) {
        free(_textureUniforms);
    }
    if (_colorUniforms) {
        free(_colorUniforms);
    }
    if (_currentUniforms) {
        free(_currentUniforms);
    }
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

- (void)compileColorShaders {
    // load shaders
    GLuint vertexShader = [self compileShader:@"AHShaderColorVertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"AHShaderColorFragment" withType:GL_FRAGMENT_SHADER];
    
    // create program
    _colorProgram = glCreateProgram();
    glAttachShader(_colorProgram, vertexShader);
    glAttachShader(_colorProgram, fragmentShader);
    
    // assign pointers for position and color
    glBindAttribLocation(_colorProgram, AH_SHADER_ATTRIB_POS_COORD, "poscoord");
    
    // link program
    glLinkProgram(_colorProgram);
    
    // check for success
    GLint linkSuccess;
    glGetProgramiv(_colorProgram, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(_colorProgram, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        dlog(@"%@", messageString);
        exit(1);
    }
    
    // use program
    glUseProgram(_colorProgram);
    
    // enable pointers
    glEnableVertexAttribArray(AH_SHADER_ATTRIB_POS_COORD);
    
    // assign pointers for
    _colorUniforms[AH_SHADER_UNIFORM_MODELVIEW] = glGetUniformLocation(_colorProgram, "modelview");
    _colorUniforms[AH_SHADER_UNIFORM_PROJECTION] = glGetUniformLocation(_colorProgram, "projection");
    _colorUniforms[AH_SHADER_UNIFORM_COLOR] = glGetUniformLocation(_colorProgram, "color");
    
    dlog(@"Compiled color modelview uniform %i", _colorUniforms[AH_SHADER_UNIFORM_MODELVIEW]);
    dlog(@"Compiled color projection uniform %i", _colorUniforms[AH_SHADER_UNIFORM_PROJECTION]);
    dlog(@"Compiled color sourceColor uniform %i", _colorUniforms[AH_SHADER_UNIFORM_COLOR]);
    
    dlog(@"Compiled color shaders");
}

- (void)compileTextureShaders {
    // load shaders
    GLuint vertexShader = [self compileShader:@"AHShaderTextureVertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"AHShaderTextureFragment" withType:GL_FRAGMENT_SHADER];
    
    // create program
    _textureProgram = glCreateProgram();
    glAttachShader(_textureProgram, vertexShader);
    glAttachShader(_textureProgram, fragmentShader);
    
    // assign pointers for position and color
    glBindAttribLocation(_textureProgram, AH_SHADER_ATTRIB_POS_COORD, "poscoord");
    glBindAttribLocation(_textureProgram, AH_SHADER_ATTRIB_TEX_COORD, "texcoord");
    
    // link program
    glLinkProgram(_textureProgram);
    
    // check for success
    GLint linkSuccess;
    glGetProgramiv(_textureProgram, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(_textureProgram, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        dlog(@"%@", messageString);
        exit(1);
    }
    
    // use program
    glUseProgram(_textureProgram);
    
    // enable pointers
    glEnableVertexAttribArray(AH_SHADER_ATTRIB_POS_COORD);
    glEnableVertexAttribArray(AH_SHADER_ATTRIB_TEX_COORD);
    
    // assign pointers for
    _textureUniforms[AH_SHADER_UNIFORM_MODELVIEW] = glGetUniformLocation(_textureProgram, "modelview");
    _textureUniforms[AH_SHADER_UNIFORM_PROJECTION] = glGetUniformLocation(_textureProgram, "projection");
    _textureUniforms[AH_SHADER_UNIFORM_TEXTURE_BASE] = glGetUniformLocation(_textureProgram, "textureBase");
    _textureUniforms[AH_SHADER_UNIFORM_TEXTURE_NORMAL] = glGetUniformLocation(_textureProgram, "textureNormal");
    _textureUniforms[AH_SHADER_UNIFORM_ENABLE_NORMAL] = glGetUniformLocation(_textureProgram, "isNormalEnabled");
    
    glUniform1i(_textureUniforms[AH_SHADER_UNIFORM_TEXTURE_BASE], AH_TEXTURE_SAMPLE_BASE);
    glUniform1i(_textureUniforms[AH_SHADER_UNIFORM_TEXTURE_NORMAL], AH_TEXTURE_SAMPLE_NORMAL);
    glUniform1i(_textureUniforms[AH_SHADER_UNIFORM_ENABLE_NORMAL], 0);
    
    dlog(@"Compiled texture modelview uniform %i", _textureUniforms[AH_SHADER_UNIFORM_MODELVIEW]);
    dlog(@"Compiled texture projection uniform %i", _textureUniforms[AH_SHADER_UNIFORM_PROJECTION]);
    dlog(@"Compiled texture texture uniform %i", _textureUniforms[AH_SHADER_UNIFORM_TEXTURE_BASE]);
    dlog(@"Compiled texture texture uniform %i", _textureUniforms[AH_SHADER_UNIFORM_TEXTURE_NORMAL]);
    dlog(@"Compiled texture texture uniform %i", _textureUniforms[AH_SHADER_UNIFORM_ENABLE_NORMAL]);
    
    dlog(@"Compiled texture shaders");
}


#pragma mark -
#pragma mark program


- (void)useTextureProgram {
    if (!_isUsingTextureProgram) {
        _isUsingTextureProgram = YES;
        for (int i = 0; i < AH_SHADER_UNIFORM_COUNT; i++) {
            _currentUniforms[i] = _textureUniforms[i];
        }
        glUseProgram(_textureProgram);
        [self enableNormal:_isUsingTextureNormals];
        [self setModelViewMatrix:currentModelview];
        [self setProjectionMatrix:currentProjection];
    }
}

- (void)useColorProgram {
    if (_isUsingTextureProgram) {
        _isUsingTextureProgram = NO;
        for (int i = 0; i < AH_SHADER_UNIFORM_COUNT; i++) {
            _currentUniforms[i] = _colorUniforms[i];
        }
        glUseProgram(_colorProgram);
        [self setModelViewMatrix:currentModelview];
        [self setProjectionMatrix:currentProjection];
    }
}


#pragma mark -
#pragma mark color


- (void)setColor:(GLKVector4)color {
    if (!_isUsingTextureProgram) {
        glUniform4fv(_currentUniforms[AH_SHADER_UNIFORM_COLOR], 1, color.v);
    }
}


#pragma mark -
#pragma mark matrixes


- (void)setModelViewMatrix:(GLKMatrix4)matrix {
    glUniformMatrix4fv(_currentUniforms[AH_SHADER_UNIFORM_MODELVIEW], 1, 0, matrix.m);
    currentModelview = matrix;
    [self debug];
}

- (void)setProjectionMatrix:(GLKMatrix4)matrix {
    glUniformMatrix4fv(_currentUniforms[AH_SHADER_UNIFORM_PROJECTION], 1, 0, matrix.m);
    currentProjection = matrix;
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
#pragma mark textures


- (void)enableNormal:(BOOL)enabled {
    _isUsingTextureNormals = enabled;
    if (_isUsingTextureProgram) {
        if (enabled) {
            glUniform1i(_textureUniforms[AH_SHADER_UNIFORM_ENABLE_NORMAL], 1);
        } else {
            glUniform1i(_textureUniforms[AH_SHADER_UNIFORM_ENABLE_NORMAL], 0);
        }
    }
}


@end
