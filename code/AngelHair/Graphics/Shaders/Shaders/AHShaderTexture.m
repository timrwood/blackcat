//
//  AHShaderTexture.m
//  BlackCat
//
//  Created by Tim Wood on 2/15/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHShaderManager.h"
#import "AHShaderTexture.h"


@implementation AHShaderTexture


#pragma mark -
#pragma mark compile


- (void)compile {
    GLuint program = [self programId];
    
    // load shaders
    GLuint vertexShader = [self compileShader:@"AHShaderTextureVertex"
                                withExtension:@"vsh"
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"AHShaderTextureFragment"
                                  withExtension:@"fsh"
                                       withType:GL_FRAGMENT_SHADER];
    
    // create program
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    
    // assign pointers for position and color
    glBindAttribLocation([self programId], AH_SHADER_ATTRIB_POS_COORD, "poscoord");
    glBindAttribLocation([self programId], AH_SHADER_ATTRIB_TEX_COORD, "texcoord");
    
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
    
    // assign pointers for
    [self setModelViewUniform:glGetUniformLocation(program, "modelview")];
    [self setProjectionUniform:glGetUniformLocation(program, "projection")];
    
    glUniform1i(glGetUniformLocation(program, "textureBase"), AH_TEXTURE_SAMPLE_BASE);
    glUniform1i(glGetUniformLocation(program, "textureNormal"), AH_TEXTURE_SAMPLE_NORMAL);
    
    dlog(@"Compiled texture shaders");
}


@end
