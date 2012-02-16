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


const GLubyte cubeIndices[] = {
    // front
    0, 1, 2,
    1, 2, 3,
    // left
    4, 5, 6,
    5, 6, 7,
    // right
    8, 9, 10,
    9, 10, 11,
    // top
    12, 13, 14,
    13, 14, 15,
    // bottom
    16, 17, 18,
    17, 18, 19
};


@implementation AHGraphicsCube


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        [self setVertexCount:20];
        [self setIndexCount:30];
        
        // set indices
        for (int i = 0; i < 30; i++) {
            self->indices[i] = cubeIndices[i];
        }
        
        [self setDrawType:GL_TRIANGLES];
        
        _offsetYT = 0.0f;
        _offsetYB = 0.0f;
        _rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark rect


- (void)setOffsetHorizontal:(BOOL)isHorizontal {
    _isHorizontal = isHorizontal;
}

- (void)setRightYTopOffset:(float)top andRightYBottomOffset:(float)bot {
    _offsetYT = top;
    _offsetYB = bot;
    [self updateVertices];
}

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
    
    GLKVector3 ltf = GLKVector3Make(l, t, f);
    GLKVector3 lbf = GLKVector3Make(l, b, f);
    GLKVector3 ltc = GLKVector3Make(l, t, c);
    GLKVector3 lbc = GLKVector3Make(l, b, c);
    GLKVector3 rtc = GLKVector3Make(r, t, c);
    GLKVector3 rbc = GLKVector3Make(r, b, c);
    GLKVector3 rtf = GLKVector3Make(r, t, f);
    GLKVector3 rbf = GLKVector3Make(r, b, f);
    
    if (_isHorizontal) {
        lbf.x = l + _offsetYT;
        lbc.x = l + _offsetYT;
        rbf.x = r + _offsetYB;
        rbc.x = r + _offsetYB;
    } else {
        rtc.y = t + _offsetYT;
        rbc.y = b + _offsetYB;
        rtf.y = t + _offsetYT;
        rbf.y = b + _offsetYB;
    }
    
    // update normals
    for (int i = 0; i < 4; i++) {
        // front
        self->normals[i] = GLKVector3Make(0.0f, 0.0f, 1.0f);
        
        // all other sides
        if (_isHorizontal) {
            self->normals[i + 4] = GLKVector3Normalize(GLKVector3Make(t - b, -_offsetYT, 0.0f));
            self->normals[i + 8] = GLKVector3Normalize(GLKVector3Make(b - t, _offsetYB, 0.0f));
            self->normals[i + 12] = GLKVector3Make(0.0f, 1.0f, 0.0f);
            self->normals[i + 16] = GLKVector3Make(0.0f, -1.0f, 0.0f);
        } else {
            self->normals[i + 4]  = GLKVector3Make(-1.0f, 0.0f, 0.0f);
            self->normals[i + 8]  = GLKVector3Make(1.0f, 0.0f, 0.0f);
            self->normals[i + 12] = GLKVector3Normalize(GLKVector3Make(_offsetYT, r - l, 0.0f));
            self->normals[i + 16] = GLKVector3Normalize(GLKVector3Make(-_offsetYB, l - r, 0.0f));
        }
    }
    
    // front
    self->vertices[0] = ltc;
    self->vertices[1] = lbc;
    self->vertices[2] = rtc;
    self->vertices[3] = rbc;
    
    // left
    self->vertices[4] = ltf;
    self->vertices[5] = lbf;
    self->vertices[6] = ltc;
    self->vertices[7] = lbc;
    
    // right
    self->vertices[8]  = rtf;
    self->vertices[9]  = rbf;
    self->vertices[10] = rtc;
    self->vertices[11] = rbc;
    
    // top
    self->vertices[12] = ltc;
    self->vertices[13] = ltf;
    self->vertices[14] = rtc;
    self->vertices[15] = rtf;
    
    // bottom
    self->vertices[16] = lbc;
    self->vertices[17] = lbf;
    self->vertices[18] = rbc;
    self->vertices[19] = rbf;
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
    [self setFrontTex:rect];
    [self setRightTex:rect];
    [self setLeftTex:rect];
    [self setBotTex:rect];
    [self setTopTex:rect];
}

- (void)setFrontTex:(CGRect)rect {
    float convert = (_isHorizontal ? (rect.size.width / _rect.size.width) : (rect.size.height / _rect.size.height));
    float rightTop = _offsetYT * convert;
    float rightBot = _offsetYB * convert;
    
    float l = rect.origin.x;
    float r = rect.origin.x + rect.size.width;
    float t = rect.origin.y;
    float b = rect.origin.y + rect.size.height;
    
    self->textures[0] = GLKVector2Make(l, t);
    self->textures[1] = GLKVector2Make(l, b);
    self->textures[2] = GLKVector2Make(r, t);
    self->textures[3] = GLKVector2Make(r, b);
    
    if (_isHorizontal) {
        self->textures[1].x += rightTop;
        self->textures[3].x += rightBot;
    } else {
        self->textures[2].y += rightTop;
        self->textures[3].y += rightBot;
    }
}

- (void)setRightTex:(CGRect)rect {
    float l = rect.origin.x;
    float r = rect.origin.x + rect.size.width;
    float t = rect.origin.y;
    float b = rect.origin.y + rect.size.height;
    
    self->textures[8] = GLKVector2Make(l, t);
    self->textures[9] = GLKVector2Make(l, b);
    self->textures[10] = GLKVector2Make(r, t);
    self->textures[11] = GLKVector2Make(r, b);
}

- (void)setLeftTex:(CGRect)rect {
    float l = rect.origin.x;
    float r = rect.origin.x + rect.size.width;
    float t = rect.origin.y;
    float b = rect.origin.y + rect.size.height;
    
    self->textures[4] = GLKVector2Make(l, t);
    self->textures[5] = GLKVector2Make(l, b);
    self->textures[6] = GLKVector2Make(r, t);
    self->textures[7] = GLKVector2Make(r, b);
}

- (void)setTopTex:(CGRect)rect {
    float l = rect.origin.x;
    float r = rect.origin.x + rect.size.width;
    float t = rect.origin.y;
    float b = rect.origin.y + rect.size.height;
    
    self->textures[12] = GLKVector2Make(l, t);
    self->textures[13] = GLKVector2Make(l, b);
    self->textures[14] = GLKVector2Make(r, t);
    self->textures[15] = GLKVector2Make(r, b);
}

- (void)setBotTex:(CGRect)rect {
    float l = rect.origin.x;
    float r = rect.origin.x + rect.size.width;
    float t = rect.origin.y;
    float b = rect.origin.y + rect.size.height;
    
    self->textures[16] = GLKVector2Make(l, t);
    self->textures[17] = GLKVector2Make(l, b);
    self->textures[18] = GLKVector2Make(r, t);
    self->textures[19] = GLKVector2Make(r, b);
    
    if (_isHorizontal) {
        float convert = rect.size.width / _rect.size.width;
        
        float rightTop = _offsetYT * convert;
        float rightBot = _offsetYB * convert;
        
        self->textures[16].x += rightTop;
        self->textures[17].x += rightTop;
        self->textures[18].x += rightBot;
        self->textures[19].x += rightBot;
    }
}


@end