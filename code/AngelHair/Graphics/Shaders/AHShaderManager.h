//
//  AHShaderManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/25/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


@interface AHShaderManager : NSObject {
@private;
    GLuint _positionSlot;
    GLuint _textureSlot;
    GLuint _colorSlot;
    
    GLuint _modelViewUniform;
    GLuint _projectionUniform;
    GLuint _textureUniform;
    
    GLuint _programHandle;
}


#pragma mark -
#pragma mark compile


- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType;
- (void)compileShaders;


#pragma mark -
#pragma mark program


- (void)useProgram;


#pragma mark -
#pragma mark matrixes


- (void)setModelViewMatrix:(GLKMatrix4)matrix;
- (void)setProjectionMatrix:(GLKMatrix4)matrix;


#pragma mark -
#pragma mark debug


- (void)debug;


#pragma mark -
#pragma mark offsets


- (GLuint)vertexAttribTexCoord0;
- (GLuint)vertexAttribPosition;


@end
