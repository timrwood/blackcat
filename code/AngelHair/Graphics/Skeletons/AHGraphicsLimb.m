//
//  AHGraphicsLimb.m
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHGraphicsManager.h"
#import "AHMathUtils.h"
#import "AHGraphicsLimb.h"


@implementation AHGraphicsLimb


#pragma mark -
#pragma mark init 


- (id)init {
    self = [super init];
    if (self) {
        [self setVertexCount:10];
        [self setIndexCount:10];
        
        for (int i = 0; i < 10; i++) {
            self->indices[i] = i;
            self->normals[i] = GLKVector3Make(0.0f, 0.0f, 1.0f);
        }
    }
    return self;
}


#pragma mark -
#pragma mark sizes


- (void)setWidth:(float)width {
    if (width != _width) {
        _canUseVertexCache = NO;
        _canUseTextureCache = NO;
        _width = width;
    }
}

- (void)setLength:(float)length {
    if (length != _length) {
        _canUseVertexCache = NO;
        _canUseTextureCache = NO;
        _length = length;
    }
}

- (void)setAngle:(float)angle {
    if (angle != _angle) {
        _canUseVertexCache = NO;
        if (angle > 0.0f) {
            _angle = fmodf(angle + M_TAU_2, M_TAU) - M_TAU_2;
        } else {
            _angle = fmodf(angle - M_TAU_2, M_TAU) + M_TAU_2;
        }
    }
}

- (void)setDepth:(float)depth {
    _depth = depth;
    _canUseVertexCache = NO;
}


#pragma mark -
#pragma mark texture


- (void)setTextureRect:(CGRect)rect {
    _rect = rect;
    _canUseTextureCache = NO;
}


#pragma mark -
#pragma mark cache


- (void)cacheTextureValues {
    if (_canUseTextureCache) {
        return;
    }
    
    float heightToWidth = _width / _length;
    float top = _rect.origin.y;
    float bottom = _rect.origin.y + _rect.size.height;
    float left = _rect.origin.x;
    float right = _rect.origin.x + _rect.size.width;
    
    float atBend = top + _rect.size.height / 2.0f;
    float aboveBend = atBend - _rect.size.height * heightToWidth;
    float belowBend = atBend + _rect.size.height * heightToWidth;
    
    self->textures[0] = GLKVector2Make(left,  top);
    self->textures[1] = GLKVector2Make(right, top);
    self->textures[2] = GLKVector2Make(left,  aboveBend);
    self->textures[3] = GLKVector2Make(right, aboveBend);
    self->textures[4] = GLKVector2Make(left,  atBend);
    self->textures[5] = GLKVector2Make(right, atBend);
    self->textures[6] = GLKVector2Make(left,  belowBend);
    self->textures[7] = GLKVector2Make(right, belowBend);
    self->textures[8] = GLKVector2Make(left,  bottom);
    self->textures[9] = GLKVector2Make(right, bottom);
    
    _canUseTextureCache = YES;
}

- (void)cacheVertexValues {
    if (_canUseVertexCache) {
        return;
    }
    
    float halfWidth = _width / 2.0f;
    
    float cosAngle = cosf(_angle);
    float sinAngle = -sinf(_angle);
    float cosRightAngle = cosf(_angle - M_TAU_4);
    float sinRightAngle = -sinf(_angle - M_TAU_4);
    float cosHalfRightAngle = cosf(_angle / 2.0f - M_TAU_4);
    float sinHalfRightAngle = -sinf(_angle / 2.0f - M_TAU_4);
    float atBend = _length / 2.0f - _width;
    float centerToEnd = _length / 2.0f - halfWidth;
    float aboveBend = atBend - halfWidth;
    
    // origin
    self->vertices[0] = GLKVector3Make(-halfWidth, 0.0f, _depth);
    self->vertices[1] = GLKVector3Make(halfWidth, 0.0f, _depth);

    // center
    GLKVector2 halfAngle = GLKVector2Make(halfWidth * sinHalfRightAngle, halfWidth * cosHalfRightAngle);
    GLKVector2 center = GLKVector2Make(0.0f, atBend);
    GLKVector2 endLength = GLKVector2Make(centerToEnd * sinAngle, centerToEnd * cosAngle);
    GLKVector2 afterBendLength = GLKVector2Make(halfWidth * sinAngle, halfWidth * cosAngle);
    GLKVector2 endWidth = GLKVector2Make(halfWidth * sinRightAngle, halfWidth * cosRightAngle);

    if (_angle > 0.0f) {
        float h = fmaxf(-atBend, -halfWidth * cosHalfRightAngle / sinHalfRightAngle);
        GLKVector2 centerToClip = GLKVector2Make(-halfWidth, h);
        GLKVector2 clipPoint = GLKVector2Add(center, centerToClip);
        self->vertices[4] = GLKVector3MakeWithVector2(clipPoint, _depth);
        self->vertices[5] = GLKVector3MakeWithVector2(GLKVector2Add(center, halfAngle), _depth);
    } else {
        float h = fmaxf(-atBend, halfWidth * cosHalfRightAngle / sinHalfRightAngle);
        GLKVector2 centerToClip = GLKVector2Make(halfWidth, h);
        GLKVector2 clipPoint = GLKVector2Add(center, centerToClip);
        self->vertices[4] = GLKVector3MakeWithVector2(GLKVector2Subtract(center, halfAngle), _depth);
        self->vertices[5] = GLKVector3MakeWithVector2(clipPoint, _depth);
    }
    
    // left side
    if (_angle > M_TAU_4) {
        self->vertices[2] = self->vertices[4];
        self->vertices[6] = self->vertices[4];
    } else {
        self->vertices[6] = GLKVector3MakeWithVector2(GLKVector2Add(center, GLKVector2Subtract(afterBendLength, endWidth)), _depth);
        self->vertices[2] = GLKVector3MakeWithVector2(GLKVector2Make(-halfWidth, aboveBend), _depth);
    }
    
    // right side
    if (_angle < -M_TAU_4) {
        self->vertices[3] = self->vertices[5];
        self->vertices[7] = self->vertices[5];
    } else {
        self->vertices[7] = GLKVector3MakeWithVector2(GLKVector2Add(center, GLKVector2Add(afterBendLength, endWidth)), _depth);
        self->vertices[3] = GLKVector3MakeWithVector2(GLKVector2Make(halfWidth, aboveBend), _depth);
    }
    
    self->vertices[8] = GLKVector3MakeWithVector2(GLKVector2Add(center, GLKVector2Subtract(endLength, endWidth)), _depth);
    self->vertices[9] = GLKVector3MakeWithVector2(GLKVector2Add(center, GLKVector2Add(endLength, endWidth)), _depth);
    
    _canUseVertexCache = YES;
}


#pragma mark -
#pragma mark update


- (void)update {
    if (!_canUseVertexCache) {
        [self cacheVertexValues];
    }
    if (!_canUseTextureCache) {
        [self cacheTextureValues];
    }
}


@end


