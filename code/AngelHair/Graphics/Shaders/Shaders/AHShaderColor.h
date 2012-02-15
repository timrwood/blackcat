//
//  AHShaderTexture.h
//  BlackCat
//
//  Created by Tim Wood on 2/15/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHShader.h"


@interface AHShaderColor : AHShader {
@private;
    GLuint _colorUniform;
}


#pragma mark -
#pragma mark color


- (void)setColor:(GLKVector4)color;


@end
