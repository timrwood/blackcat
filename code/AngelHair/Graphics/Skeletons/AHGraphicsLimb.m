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

- (void)setRotation:(float)rotation {
    if (rotation != _rotation) {
        _canUseCache = NO;
        _rotation = fmodf(rotation, 360.0f);
    }
}


#pragma mark -
#pragma mark texture


- (void)setTextureRect:(CGRect *)rect {
    
}


#pragma mark -
#pragma mark draw


- (void)cacheValues {
    
}


@end
