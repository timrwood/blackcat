//
//  AHGraphicsPolygon.m
//  BlackCat
//
//  Created by Tim Wood on 2/8/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsPolygon.h"


@implementation AHGraphicsPolygon


#pragma mark -
#pragma mark init


- (id)initFromPoints:(GLKVector2 *)points andTexPoints:(GLKVector2 *)texPoints andCount:(int)count {
    self = [super init];
    if (self) {
        [self setVertexCount:count];
        [self setPositionVertices:points];
        [self setTextureVertices:texPoints];
    }
    return self;
}


#pragma mark -
#pragma mark setters


- (void)setPositionVertices:(GLKVector2 *)verts {
    for (int i = 0; i < [self vertexCount]; i++) {
        self->vertices[i] = verts[i];
    }
}

- (void)setTextureVertices:(GLKVector2 *)verts {
    for (int i = 0; i < [self vertexCount]; i++) {
        self->textures[i] = verts[i];
    }
}

- (void)setDisplayAsFan:(BOOL)asFan {
    
}


@end
