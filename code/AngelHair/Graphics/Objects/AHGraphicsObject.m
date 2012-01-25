//
//  AHGraphicsObject.m
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsManager.h"
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


- (void)addToLayerIndex:(int)i {
    [[AHGraphicsManager manager] addObject:self toLayerIndex:i];
}

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
    if (_count != newCount) {
        if (vertices) {
            free(vertices);
        }
        if (textures) {
            free(textures);
        }
    }
    _count = newCount;
    self->vertices = (GLKVector2 *) malloc(sizeof(GLKVector2) * _count);
    self->textures = (GLKVector2 *) malloc(sizeof(GLKVector2) * _count);
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
    _texture = [[AHTextureManager manager] textureForKey:key];
}

- (AHTextureInfo *)texture {
    return _texture;
}


#pragma mark -
#pragma mark draw


- (void)draw {
    if (_count > 0) {
        [[AHGraphicsManager manager] drawPointerArrayPosition:self->vertices
                                                   andTexture:self->textures
                                                     andCount:_count 
                                                  andDrawType:GL_TRIANGLE_STRIP];
    }
}


#pragma mark -
#pragma mark update


- (void)update {
    
}


@end
