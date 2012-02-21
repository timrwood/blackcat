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
    0, 2, 1,
    1, 2, 3,
    // left
    4, 6, 5,
    5, 6, 7,
    // right
    8, 9, 10,
    10, 9, 11,
    // top
    12, 13, 14,
    14, 13, 15,
    // bottom
    16, 18, 17,
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
    
    // front
    self->vertices[0].position = ltc;
    self->vertices[1].position = lbc;
    self->vertices[2].position = rtc;
    self->vertices[3].position = rbc;
    /*
    // debug
    self->vertices[0].position = rbc;
    self->vertices[1].position = rbc;
    self->vertices[2].position = rbc;
    self->vertices[3].position = rbc;
    */
    // left
    self->vertices[4].position = ltf;
    self->vertices[5].position = lbf;
    self->vertices[6].position = ltc;
    self->vertices[7].position = lbc;
    
    // right
    self->vertices[8].position  = rtf;
    self->vertices[9].position  = rbf;
    self->vertices[10].position = rtc;
    self->vertices[11].position = rbc;
    
    // top
    self->vertices[12].position = ltc;
    self->vertices[13].position = ltf;
    self->vertices[14].position = rtc;
    self->vertices[15].position = rtf;
    
    // bottom
    self->vertices[16].position = lbc;
    self->vertices[17].position = lbf;
    self->vertices[18].position = rbc;
    self->vertices[19].position = rbf;
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
    
    self->vertices[0].texture = GLKVector2Make(l, t);
    self->vertices[1].texture = GLKVector2Make(l, b);
    self->vertices[2].texture = GLKVector2Make(r, t);
    self->vertices[3].texture = GLKVector2Make(r, b);
    
    if (_isHorizontal) {
        self->vertices[1].texture.x += rightTop;
        self->vertices[3].texture.x += rightBot;
    } else {
        self->vertices[2].texture.y += rightTop;
        self->vertices[3].texture.y += rightBot;
    }
}

- (void)setRightTex:(CGRect)rect {
    float l = rect.origin.x;
    float r = rect.origin.x + rect.size.width;
    float t = rect.origin.y;
    float b = rect.origin.y + rect.size.height;
    
    self->vertices[8].texture = GLKVector2Make(l, t);
    self->vertices[9].texture = GLKVector2Make(l, b);
    self->vertices[10].texture = GLKVector2Make(r, t);
    self->vertices[11].texture = GLKVector2Make(r, b);
}

- (void)setLeftTex:(CGRect)rect {
    float l = rect.origin.x;
    float r = rect.origin.x + rect.size.width;
    float t = rect.origin.y;
    float b = rect.origin.y + rect.size.height;
    
    self->vertices[4].texture = GLKVector2Make(l, t);
    self->vertices[5].texture = GLKVector2Make(l, b);
    self->vertices[6].texture = GLKVector2Make(r, t);
    self->vertices[7].texture = GLKVector2Make(r, b);
}

- (void)setTopTex:(CGRect)rect {
    float l = rect.origin.x;
    float r = rect.origin.x + rect.size.width;
    float t = rect.origin.y;
    float b = rect.origin.y + rect.size.height;
    
    self->vertices[12].texture = GLKVector2Make(l, t);
    self->vertices[13].texture = GLKVector2Make(l, b);
    self->vertices[14].texture = GLKVector2Make(r, t);
    self->vertices[15].texture = GLKVector2Make(r, b);
}

- (void)setBotTex:(CGRect)rect {
    float l = rect.origin.x;
    float r = rect.origin.x + rect.size.width;
    float t = rect.origin.y;
    float b = rect.origin.y + rect.size.height;
    
    self->vertices[16].texture = GLKVector2Make(l, t);
    self->vertices[17].texture = GLKVector2Make(l, b);
    self->vertices[18].texture = GLKVector2Make(r, t);
    self->vertices[19].texture = GLKVector2Make(r, b);
    
    if (_isHorizontal) {
        float convert = rect.size.width / _rect.size.width;
        
        float rightTop = _offsetYT * convert;
        float rightBot = _offsetYB * convert;
        
        self->vertices[16].texture.x += rightTop;
        self->vertices[17].texture.x += rightTop;
        self->vertices[18].texture.x += rightBot;
        self->vertices[19].texture.x += rightBot;
    }
}


#pragma mark -
#pragma mark setup


- (void)setup {
    [self calculateTangentAndBinormals];
    [super setup];
}


@end