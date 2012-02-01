//
//  AHGraphicsRect.m
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHGraphicsManager.h"
#import "AHGraphicsRect.h"


@implementation AHGraphicsRect


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        [self setVertexCount:4];
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
    self->vertices[0] = GLKVector2Make(rect.origin.x,                   rect.origin.y);
    self->vertices[1] = GLKVector2Make(rect.origin.x,                   rect.origin.y + rect.size.height);
    self->vertices[2] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y);
    self->vertices[3] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}


#pragma mark -
#pragma mark tex


- (void)setTexFromCenter:(GLKVector2)center andRadius:(float)radius {
    [self setTexFromCenter:center andSize:CGSizeMake(radius, radius)];
}

- (void)setTexFromCenter:(GLKVector2)center andSize:(CGSize)size {
    CGRect rect = CGRectInset(CGRectMake(center.x, center.y, 0.0f, 0.0f), -size.width, -size.height);
    [self setTex:rect];
}

- (void)setTex:(CGRect)rect {
    self->textures[0] = GLKVector2Make(rect.origin.x,                   rect.origin.y);
    self->textures[1] = GLKVector2Make(rect.origin.x,                   rect.origin.y + rect.size.height);
    self->textures[2] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y);
    self->textures[3] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}


@end
