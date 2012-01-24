//
//  AHGraphicsLimb.m
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsLimb.h"


@implementation AHGraphicsLimb


#pragma mark -
#pragma mark init 


- (id)init {
    self = [super init];
    if (self) {
        [self setVertexCount:10];
    }
    return self;
}

#pragma mark -
#pragma mark sizes


- (void)setWidth:(float)width {
    if (width != _width) {
        _canUseCache = NO;
        _width = width;
    }
}

- (void)setLength:(float)length {
    if (length != _length) {
        _canUseCache = NO;
        _length = length;
    }
}

- (void)setAngle:(float)angle {
    if (angle != _angle) {
        _canUseCache = NO;
        _angle = fmodf(angle, M_PI * 2.0f);
    }
}


#pragma mark -
#pragma mark texture


- (void)setTextureRect:(CGRect *)rect {
    
}


#pragma mark -
#pragma mark draw


- (void)cacheValues {
    if (_canUseCache) {
        return;
    }
    
    float atBend = _length / 2.0f;
    float aboveBend = atBend - _width;
    float belowBend = atBend + _width;
    
    //self->vertices[0] = GLKVector2Make(-_width, 0.0f);
    //self->vertices[1] = GLKVector2Make(_width, 0.0f);
    
    // left side
    if (_angle < 90.0f) {
        
    }
    
    _canUseCache = YES;
}

- (void)draw {
    
}


@end


