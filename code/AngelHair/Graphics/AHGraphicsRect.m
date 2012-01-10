//
//  AHGraphicsRect.m
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

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


- (void)setRectFromCenter:(CGPoint)center andRadius:(float)radius {
    [self setRectFromCenter:center andSize:CGSizeMake(radius, radius)];
}

- (void)setRectFromCenter:(CGPoint)center andSize:(CGSize)size {
    CGRect rect = CGRectInset(CGRectMake(center.x, center.y, 0.0f, 0.0f), -size.width, -size.height);
    [self setRect:rect];
}

- (void)setRect:(CGRect)rect {
    self->vertices[0] = CGPointMake(rect.origin.x,                   rect.origin.y);
    self->vertices[1] = CGPointMake(rect.origin.x,                   rect.origin.y + rect.size.height);
    self->vertices[2] = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    self->vertices[3] = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}


#pragma mark -
#pragma mark tex


- (void)setTexFromCenter:(CGPoint)center andRadius:(float)radius {
    [self setTexFromCenter:center andSize:CGSizeMake(radius, radius)];
}

- (void)setTexFromCenter:(CGPoint)center andSize:(CGSize)size {
    CGRect rect = CGRectInset(CGRectMake(center.x, center.y, 0.0f, 0.0f), -size.width, -size.height);
    [self setTex:rect];
}

- (void)setTex:(CGRect)rect {
    self->textures[0] = CGPointMake(rect.origin.x,                   rect.origin.y);
    self->textures[1] = CGPointMake(rect.origin.x,                   rect.origin.y + rect.size.height);
    self->textures[2] = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    self->textures[3] = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}


@end
