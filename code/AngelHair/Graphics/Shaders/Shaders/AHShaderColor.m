//
//  AHShaderTexture.m
//  BlackCat
//
//  Created by Tim Wood on 2/15/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHShaderManager.h"
#import "AHShaderColor.h"


@implementation AHShaderColor


#pragma mark -
#pragma mark compile


- (void)compile {
    GLuint program = [self programId];
    
    // load shaders
    GLuint vertexShader = [self compileShader:@"AHShaderColorVertex"
                                withExtension:@"vsh"
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"AHShaderColorFragment"
                                  withExtension:@"fsh"
                                       withType:GL_FRAGMENT_SHADER];
    
    // create program
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    
    // assign pointers for position and color
    glBindAttribLocation([self programId], AH_SHADER_ATTRIB_POS_COORD, "poscoord");
    
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

    // assign pointers for
    [self setModelViewUniform:glGetUniformLocation(program, "modelview")];
    [self setProjectionUniform:glGetUniformLocation(program, "projection")];
    _colorUniform = glGetUniformLocation(program, "color");
    
    dlog(@"Compiled color shaders into program %i", program);
}


#pragma mark -
#pragma mark color


- (void)setColor:(GLKVector4)color {
    if ([self isActive]) {
        glUniform4fv(_colorUniform, 1, color.v);
    }
}


@end
