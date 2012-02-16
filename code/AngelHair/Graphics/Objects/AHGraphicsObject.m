//
//  AHGraphicsObject.m
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHShaderManager.h"
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
        _canBeBuffered = YES;
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark cache


- (void)doNotBuffer {
    _canBeBuffered = NO;
}

- (void)buffer {
    if (!_canBeBuffered) {
        return;
    }
    glGenBuffers(1, &_bufferId);
    glBindBuffer(GL_ARRAY_BUFFER, _bufferId);
    glBufferData(GL_ARRAY_BUFFER, _count * sizeof(GLKVector3), vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_arrayId);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _arrayId);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, _indexCount * sizeof(GLubyte), indices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    _isBuffered = YES;
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
    //[self buffer];
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
        if (normals) {
            free(normals);
        }
    }
    _count = newCount;
    self->vertices = (GLKVector3 *) malloc(sizeof(GLKVector3) * _count);
    self->textures = (GLKVector2 *) malloc(sizeof(GLKVector2) * _count);
    self->normals = (GLKVector3 *) malloc(sizeof(GLKVector3) * _count);
}

- (void)setIndexCount:(int)newCount {
    if (_indexCount != newCount) {
        if (indices) {
            free(indices);
        }
    }
    _indexCount = newCount;
    self->indices = (GLubyte *) malloc(sizeof(GLubyte) * _indexCount);
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
    if (indices) {
        free(indices);
    }
    if (normals) {
        free(normals);
    }
    [self removeFromParentLayer];
}


#pragma mark -
#pragma mark textures


- (void)setTextureKey:(NSString *)key {
    _texture = [[AHTextureManager manager] textureForKey:key];
}

- (void)setNormalTextureKey:(NSString *)key {
    _normalTexture = [[AHTextureManager manager] textureForKey:key];
}

- (AHTextureInfo *)texture {
    return _texture;
}

- (AHTextureInfo *)normalTexture {
    return _normalTexture;
}


#pragma mark -
#pragma mark draw


- (void)draw {
    glPushGroupMarkerEXT(0, "Drawing Graphics Object");
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
        [self drawActual];
    }
    if (_isOffset || _rotation != 0.0f) {
        [[AHGraphicsManager manager] modelPop];
    }
    glPopGroupMarkerEXT();
}

- (void)drawActual {
    //glBindBuffer(GL_ARRAY_BUFFER, _bufferId);
    //glVertexAttribPointer(AH_SHADER_ATTRIB_POS_COORD, 2, GL_FLOAT, GL_FALSE, 0, (void*)0);
    //glEnableVertexAttribArray(AH_SHADER_ATTRIB_POS_COORD);
    //glVertexAttribPointer(AH_SHADER_ATTRIB_TEX_COORD, 2, GL_FLOAT, GL_FALSE, 0, self->textures);
    //glEnableVertexAttribArray(AH_SHADER_ATTRIB_TEX_COORD);
    
    //glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _arrayId);
    //glDrawElements(GL_TRIANGLE_STRIP, sizeof(indices)/sizeof(GLubyte), GL_UNSIGNED_BYTE, (void*)0);
    
    glVertexAttribPointer(AH_SHADER_ATTRIB_TEX_COORD, 2, GL_FLOAT, GL_FALSE, 0, self->textures);
    glVertexAttribPointer(AH_SHADER_ATTRIB_POS_COORD, 3, GL_FLOAT, GL_FALSE, 0, self->vertices);
    glVertexAttribPointer(AH_SHADER_ATTRIB_NOR_COORD, 3, GL_FLOAT, GL_FALSE, 0, self->normals);
	
    //glDrawArrays(_drawType, 0, _count);
    glDrawElements(_drawType, _indexCount, GL_UNSIGNED_BYTE, self->indices);
    //glBindBuffer(GL_ARRAY_BUFFER, 0);
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
