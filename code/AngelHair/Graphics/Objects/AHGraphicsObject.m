//
//  AHGraphicsObject.m
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsLayer.h"
#import "AHGraphicsObject.h"
#import "AHTextureManager.h"


@implementation AHGraphicsObject


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark layer


- (void)setLayer:(AHGraphicsLayer *)layer {
    _layer = layer;
}

- (void)removeFromParentLayer {
    if (_layer) {
        [_layer removeObject:self];
        _layer = nil;
    }
}


#pragma mark -
#pragma mark setup


- (void)setup {
    
}


#pragma mark -
#pragma mark vertices


- (void)setVertexCount:(int)newCount {
    if (count != newCount) {
        if (vertices) {
            free(vertices);
        }
        if (textures) {
            free(textures);
        }
    }
    count = newCount;
    self->vertices = (CGPoint *) malloc(sizeof(CGPoint) * count);
    self->textures = (CGPoint *) malloc(sizeof(CGPoint) * count);
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval {
    if (vertices) {
        free(vertices);
    }
    if (textures) {
        free(textures);
    }
    [self removeFromParentLayer];
}


#pragma mark -
#pragma mark textures


- (void)setTextureKey:(NSString *)key {
    texture = [[AHTextureManager manager] textureForKey:key];
}

- (GLuint)textureName {
    if (texture) {
        return [[texture info] name];
    }
    dlog(@"Texture not loaded for this object.");
    return 0;
}


#pragma mark -
#pragma mark draw


- (void)draw {
    
}


@end
