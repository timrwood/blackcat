//
//  AHShader.h
//  BlackCat
//
//  Created by Tim Wood on 2/15/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface AHShader : NSObject {
@private;
    GLuint _programId;
    
    GLuint _modelViewUniform;
    GLuint _projectionUniform;
    GLint _lightPositionUniform;
    
    BOOL _isActive;
    
    GLKMatrix4 _projectionMatrix;
    GLKMatrix4 _modelViewMatrix;
    GLKVector3 _lightPosition;
}


#pragma mark -
#pragma mark compile shaders


- (GLuint)compileShader:(NSString *)shaderName
          withExtension:(NSString *)ext
               withType:(GLenum)shaderType;
- (void)compile;


#pragma mark -
#pragma mark uniforms


- (void)setLightPositionUniform:(GLuint)uniform;
- (void)setLightPosition:(GLKVector3)position;
- (void)setProjectionUniform:(GLuint)uniform;
- (void)setModelViewUniform:(GLuint)uniform;
- (void)setProjection:(GLKMatrix4)matrix;
- (void)setModelView:(GLKMatrix4)matrix;
- (void)setNormal:(GLKMatrix4)matrix;


#pragma mark -
#pragma mark activate


- (GLuint)programId;
- (void)activate;
- (void)deactivate;
- (BOOL)isActive;


@end
