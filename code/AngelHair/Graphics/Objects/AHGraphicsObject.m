//
//  AHGraphicsObject.m
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
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
        _drawType = GL_TRIANGLE_STRIP;
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark layer


- (void)setHudLayer:(BOOL)isForHud {
    _isForHud = isForHud;
}

- (void)setLayerIndex:(int)i {
    _layerIndex = i;
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
    if (_isForHud) {
        [[AHGraphicsManager manager] addObjectToHudLayer:self];
    } else {
        [[AHGraphicsManager manager] addObject:self toLayerIndex:_layerIndex];
    }
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

- (int)vertexCount {
    return _count;
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
    if (_isOffset) {
        [[AHGraphicsManager manager] modelPush];
        if (_rotation == 0.0f) {
            [[AHGraphicsManager manager] modelMove:_position];
        } else {
            [[AHGraphicsManager manager] modelMove:_position thenRotate:_rotation];
        }
    } else if (_rotation != 0.0f) {
        [[AHGraphicsManager manager] modelPush];
        [[AHGraphicsManager manager] modelRotate:_rotation];
    }
    if (_count > 0) {
        [[AHGraphicsManager manager] drawPointerArrayPosition:self->vertices
                                                   andTexture:self->textures
                                                     andCount:_count 
                                                  andDrawType:_drawType];
    }
    if (_isOffset || _rotation != 0.0f) {
        [[AHGraphicsManager manager] modelPop];
    }
}

- (void)setDrawType:(GLenum)drawType {
    _drawType = drawType;
}


#pragma mark -
#pragma mark offset


- (void)setPosition:(GLKVector2)position {
    _position = position;
    if (position.x == 0 && position.y == 0) {
        _isOffset = NO;
    } else {
        _isOffset = YES;
    }
}

- (void)setRotation:(float)rotation {
    _rotation = rotation;
}


#pragma mark -
#pragma mark update


- (void)update {
    
}


@end
