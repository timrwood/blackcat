//
//  AHShaderManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/25/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define AH_SHADER_UNIFORM_MODELVIEW 0
#define AH_SHADER_UNIFORM_PROJECTION 1
#define AH_SHADER_UNIFORM_TEXTURE 2
#define AH_SHADER_UNIFORM_COLOR 3
#define AH_SHADER_UNIFORM_COUNT 4

#define AH_TEXTURE_SAMPLE_BASE 0
#define AH_TEXTURE_SAMPLE_NORMAL 1

#define AH_SHADER_ATTRIB_POS_COORD 0
#define AH_SHADER_ATTRIB_TEX_COORD 1


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
#pragma mark debug


- (void)debug;


@end
