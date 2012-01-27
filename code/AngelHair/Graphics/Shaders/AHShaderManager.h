//
//  AHShaderManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/25/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define AH_SHADER_MODELVIEW_UNIFORM 0
#define AH_SHADER_PROJECTION_UNIFORM 1
#define AH_SHADER_TEXTURE_UNIFORM 2
#define AH_SHADER_COLOR_UNIFORM 3
#define AH_SHADER_UNIFORM_COUNT 4

#define AH_SHADER_POSITION_ATTRIB 0
#define AH_SHADER_TEXTURE_ATTRIB 1


@interface AHShaderManager : NSObject {
@private;
    GLuint *_textureUniforms;
    GLuint *_colorUniforms;
    GLuint *_currentUniforms;
    
    GLuint _textureProgram;
    GLuint _colorProgram;
    
    BOOL _isUsingTextureProgram;
    
    GLKMatrix4 currentModelview;
    GLKMatrix4 currentProjection;
    
    GLuint _currentTexture;
}


#pragma mark -
#pragma mark compile


- (GLuint)compileShader:(NSString*)shaderName
               withType:(GLenum)shaderType;
- (void)compileColorShaders;
- (void)compileTextureShaders;


#pragma mark -
#pragma mark program


- (void)useTextureProgram;
- (void)useColorProgram;


#pragma mark -
#pragma mark color


- (void)setColor:(GLKVector4)color;


#pragma mark -
#pragma mark matrixes


- (void)setModelViewMatrix:(GLKMatrix4)matrix;
- (void)setProjectionMatrix:(GLKMatrix4)matrix;


#pragma mark -
#pragma mark texture


- (void)setTexture0:(GLuint)tex0;


#pragma mark -
#pragma mark debug


- (void)debug;


@end
