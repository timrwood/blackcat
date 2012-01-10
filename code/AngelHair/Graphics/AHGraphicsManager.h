//
//  AHGraphicsManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import <GLKit/GLKit.h>

#import "AHSubSystem.h"


@interface AHGraphicsManager : NSObject <AHSubSystem> {
@private;
    GLuint _program;
    
    EAGLContext *_eaglContext;
    GLKBaseEffect *_baseEffect;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}


#pragma mark -
#pragma mark singleton


+ (AHGraphicsManager *)manager;


#pragma mark -
#pragma mark vars


- (EAGLContext *)context;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark draw


- (void)draw;


#pragma mark -
#pragma mark shaders


- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;


#pragma mark -
#pragma mark program


- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;


@end
