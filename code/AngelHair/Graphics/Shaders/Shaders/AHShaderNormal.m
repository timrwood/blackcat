//
//  AHShaderTexture.m
//  BlackCat
//
//  Created by Tim Wood on 2/15/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHShaderManager.h"
#import "AHShaderNormal.h"


@implementation AHShaderNormal


#pragma mark -
#pragma mark compile


- (void)compile {
    GLuint program = [self programId];
    
    // load shaders
    GLuint vertexShader = [self compileShader:@"AHShaderNormalVertex"
                                withExtension:@"vsh"
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"AHShaderNormalFragment"
                                  withExtension:@"fsh"
                                       withType:GL_FRAGMENT_SHADER];
    
    // create program
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    
    // assign pointers for position and color
    glBindAttribLocation(program, AH_SHADER_ATTRIB_POS_COORD, "poscoord");
    glBindAttribLocation(program, AH_SHADER_ATTRIB_TEX_COORD, "texcoord");
    glBindAttribLocation(program, AH_SHADER_ATTRIB_NOR_COORD, "norcoord");
    
    // link program
    glLinkProgram(program);
    
    // check for success
    GLint linkSuccess;
    glGetProgramiv(program, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(program, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        dlog(@"%@", messageString);
        exit(1);
    }
    
    // use program
    glUseProgram(program);
    
    // enable pointers
    glEnableVertexAttribArray(AH_SHADER_ATTRIB_POS_COORD);
    glEnableVertexAttribArray(AH_SHADER_ATTRIB_TEX_COORD);
    glEnableVertexAttribArray(AH_SHADER_ATTRIB_NOR_COORD);
    
    // assign pointers for
    [self setModelViewUniform:glGetUniformLocation(program, "modelview")];
    [self setProjectionUniform:glGetUniformLocation(program, "projection")];
    [self setLightPositionUniform:glGetUniformLocation(program, "lightPosition")];
    _normalUniform = glGetUniformLocation(program, "normalMatrix");
    
    glUniform1i(glGetUniformLocation(program, "textureBase"), AH_TEXTURE_SAMPLE_BASE);
    glUniform1i(glGetUniformLocation(program, "textureNormal"), AH_TEXTURE_SAMPLE_NORMAL);
    
    dlog(@"Compiled texture shaders");
}


#pragma mark -
#pragma mark matrices


- (void)setNormal:(GLKMatrix4)matrix {
    _normalMatrix = matrix;
    if ([self isActive]) {
        glUniformMatrix4fv(_normalUniform, 1, 0, _normalMatrix.m);
    }
}


#pragma mark -
#pragma mark activate


- (void)activate {
    [super activate];
    glUniformMatrix4fv(_normalUniform, 1, 0, _normalMatrix.m);
}


@end
