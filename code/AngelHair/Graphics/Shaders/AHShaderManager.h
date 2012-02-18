//
//  AHShaderManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/25/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define AH_TEXTURE_SAMPLE_BASE 0
#define AH_TEXTURE_SAMPLE_NORMAL 2

#define AH_SHADER_ATTRIB_POS_COORD   0
#define AH_SHADER_ATTRIB_TEX_COORD   2
#define AH_SHADER_ATTRIB_NOR_COORD   4
#define AH_SHADER_ATTRIB_BINOR_COORD 6
#define AH_SHADER_ATTRIB_TAN_COORD   8


#import "AHSubSystem.h"
#import "AHShaderColor.h"
#import "AHShaderTexture.h"
#import "AHShaderNormal.h"


@interface AHShaderManager : NSObject <AHSubSystem> {
@private;
    AHShaderColor   *_colorShader;
    AHShaderTexture *_textureShader;
    AHShaderNormal  *_normalShader;
    AHShader *_currentShader;
}


#pragma mark -
#pragma mark singleton


+ (AHShaderManager *)manager;


#pragma mark -
#pragma mark program


- (void)useNormalProgram;
- (void)useTextureProgram;
- (void)useColorProgram;


#pragma mark -
#pragma mark color


- (void)setColor:(GLKVector4)color;


#pragma mark -
#pragma mark matrixes


- (void)setModelViewMatrix:(GLKMatrix4)matrix;
- (void)setProjectionMatrix:(GLKMatrix4)matrix;
- (void)setNormalMatrix:(GLKMatrix4)matrix;
- (void)setLightPosition:(GLKVector3)lightPosition;


#pragma mark -
#pragma mark debug


- (void)debug;


@end
