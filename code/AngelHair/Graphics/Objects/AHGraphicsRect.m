//
//  AHGraphicsRect.m
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHGraphicsManager.h"
#import "AHGraphicsRect.h"


@interface AHGraphicsRect()


- (void)updateVertices;


@end


const GLubyte rectIndices[] = {
    0, 1, 2,
    1, 2, 3
};


@implementation AHGraphicsRect


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _depth = 3.0f;
        [self setVertexCount:4];
        [self setIndexCount:4];
        
        for (int i = 0; i < 4; i++) {
            self->indices[i] = i;
            self->normals[i] = GLKVector3Make(0.0f, 0.0f, 1.0f);
        }
    }
    return self;
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

- (void)setDepth:(float)depth {
    _depth = depth;
    [self updateVertices];
}

- (void)updateVertices {
    float l = _rect.origin.x;
    float r = _rect.origin.x + _rect.size.width;
    float t = _rect.origin.y;
    float b = _rect.origin.y + _rect.size.height;

    self->vertices[0] = GLKVector3Make(l, t, _depth);
    self->vertices[1] = GLKVector3Make(l, b, _depth);
    self->vertices[2] = GLKVector3Make(r, t, _depth);
    self->vertices[3] = GLKVector3Make(r, b, _depth);
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
}


@end
