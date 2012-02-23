//
//  AHParticlePointRenderer.m
//  BlackCat
//
//  Created by Tim Wood on 2/22/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHShaderManager.h"
#import "AHParticlePointRenderer.h"
#import "AHGraphicsManager.h"


@implementation AHParticlePointRenderer


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark -
#pragma mark size


- (void)setMax:(int)max {
    if (_max != max) {
        if (_points) {
            free(_points);
        }
        _max = max;
        _points = (GLKVector3 *) malloc(sizeof(GLKVector3) * _max);
    }
}


#pragma mark -
#pragma mark update


- (void)updateParticle:(AHParticle *)particle atIndex:(int)index {
    if (index < _max) {
        _points[index] = particle->position;
    }
}


#pragma mark -
#pragma mark draw


- (void)draw {
    [[AHShaderManager manager] useColorProgram];
    [[AHShaderManager manager] setColor:GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f)];
    glVertexAttribPointer(AH_SHADER_ATTRIB_POS_COORD, 3, GL_FLOAT, GL_FALSE, 0, _points);
	glDrawArrays(GL_POINTS, 0, count);
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval {
    if (_points) {
        free(_points);
    }
}


@end
