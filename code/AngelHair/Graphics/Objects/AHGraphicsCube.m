//
//  AHGraphicsCube.m
//  BlackCat
//
//  Created by Tim Wood on 2/10/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsCube.h"


@interface AHGraphicsCube()


- (void)updateVertices;


@end


@implementation AHGraphicsCube


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        [self setVertexCount:8];
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark rect


- (void)setRectFromCenter:(GLKVector2)center andRadius:(float)radius {
    [self setRectFromCenter:center andSize:CGSizeMake(radius, radius)];
}

- (void)setRectFromCenter:(GLKVector2)center andSize:(CGSize)size {
    CGRect rect = CGRectInset(CGRectMake(center.x, center.y, 0.0f, 0.0f), -size.width, -size.height);
    [self setRect:rect];
}

- (void)setRect:(CGRect)rect {
    _rect = rect;
    [self updateVertices];
}

- (void)setStartDepth:(float)startDepth endDepth:(float)endDepth {
    _startDepth = startDepth;
    _endDepth = endDepth;
    [self updateVertices];
}

- (void)updateVertices {
    float l = _rect.origin.x;
    float r = _rect.origin.x + _rect.size.width;
    float t = _rect.origin.y;
    float b = _rect.origin.y + _rect.size.height;
    float c = _startDepth;
    float f = _endDepth;
    
    self->vertices[0] = GLKVector3Make(l, t, f);
    self->vertices[1] = GLKVector3Make(l, b, f);
    self->vertices[2] = GLKVector3Make(l, t, c);
    self->vertices[3] = GLKVector3Make(l, b, c);
    self->vertices[4] = GLKVector3Make(r, t, c);
    self->vertices[5] = GLKVector3Make(r, b, c);
    self->vertices[6] = GLKVector3Make(r, t, f);
    self->vertices[7] = GLKVector3Make(r, b, f);
}


#pragma mark -
#pragma mark tex


- (void)setTexFromCenter:(GLKVector2)center andRadius:(float)radius {
    [self setTexFromCenter:center andSize:CGSizeMake(radius, radius)];
}

- (void)setTexFromCenter:(GLKVector2)center andSize:(CGSize)size {
    CGRect rect;
    rect.origin.x = center.x - size.width;
    rect.origin.y = center.y - size.height;
    rect.size.width = size.width * 2.0f;
    rect.size.height = size.height * 2.0f;
    [self setTex:rect];
}

- (void)setTex:(CGRect)rect {
    self->textures[0] = GLKVector2Make(rect.origin.x,                   rect.origin.y);
    self->textures[1] = GLKVector2Make(rect.origin.x,                   rect.origin.y + rect.size.height);
    self->textures[2] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y);
    self->textures[3] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    self->textures[4] = GLKVector2Make(rect.origin.x,                   rect.origin.y);
    self->textures[5] = GLKVector2Make(rect.origin.x,                   rect.origin.y + rect.size.height);
    self->textures[6] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y);
    self->textures[7] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}


@end