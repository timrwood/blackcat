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


@implementation AHGraphicsCube


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        [self setVertexCount:20];
        _offsetYT = 0.0f;
        _offsetYB = 0.0f;
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
        lbf.x = l + _offsetYB;
        lbc.x = l + _offsetYB;
        rbf.x = r + _offsetYT;
        rbc.x = r + _offsetYT;
    } else {
        rtc.y = t + _offsetYT;
        rbc.y = b + _offsetYB;
        rtf.y = t + _offsetYT;
        rbf.y = b + _offsetYB;
    }
    
    self->vertices[0] = ltf;
    self->vertices[1] = lbf;
    self->vertices[2] = ltc;
    self->vertices[3] = lbc;
    self->vertices[4] = rtc;
    self->vertices[5] = rbc;
    self->vertices[6] = rtf;
    self->vertices[7] = rbf;
    
    // seperate side and top
    self->vertices[8] = rbf;
    self->vertices[9] = ltf;
    
    // top
    self->vertices[10] = ltf;
    self->vertices[11] = ltc;
    self->vertices[12] = rtf;
    self->vertices[13] = rtc;
    
    // seperate top and bottom
    self->vertices[14] = rtc;
    self->vertices[15] = lbf;
    
    // bottom
    self->vertices[16] = lbf;
    self->vertices[17] = lbc;
    self->vertices[18] = rbf;
    self->vertices[19] = rbc;
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
    float convert = rect.size.height / _rect.size.height;
    if (_isHorizontal) {
        convert = rect.size.width / _rect.size.width;
    }
    float rightTop = _offsetYT * convert;
    float rightBot = _offsetYB * convert;
    
    self->textures[0] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y);
    self->textures[1] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    self->textures[2] = GLKVector2Make(rect.origin.x,                   rect.origin.y);
    self->textures[3] = GLKVector2Make(rect.origin.x,                   rect.origin.y + rect.size.height);
    self->textures[4] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y);
    self->textures[5] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    self->textures[6] = GLKVector2Make(rect.origin.x,                   rect.origin.y);
    self->textures[7] = GLKVector2Make(rect.origin.x,                   rect.origin.y + rect.size.height);
    
    if (_isHorizontal) {
        self->textures[1].x += rightTop;
        self->textures[3].x += rightBot;
        self->textures[5].x += rightTop;
        self->textures[7].x += rightBot;
    } else {
        self->textures[4].y += rightTop;
        self->textures[5].y += rightBot;
        self->textures[6].y += rightTop;
        self->textures[7].y += rightBot;
    }
}

- (void)setTopTex:(CGRect)rect {
    self->textures[10] = GLKVector2Make(rect.origin.x,                   rect.origin.y);
    self->textures[11] = GLKVector2Make(rect.origin.x,                   rect.origin.y + rect.size.height);
    self->textures[12] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y);
    self->textures[13] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}

- (void)setBotTex:(CGRect)rect {
    
    
    self->textures[16] = GLKVector2Make(rect.origin.x,                   rect.origin.y);
    self->textures[17] = GLKVector2Make(rect.origin.x,                   rect.origin.y + rect.size.height);
    self->textures[18] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y);
    self->textures[19] = GLKVector2Make(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    
    if (_isHorizontal) {
        float convert = rect.size.width / _rect.size.width;
        
        float rightTop = _offsetYT * convert;
        float rightBot = _offsetYB * convert;
        
        self->textures[16].x += rightBot;
        self->textures[17].x += rightBot;
        self->textures[18].x += rightTop;
        self->textures[19].x += rightTop;
    }
}


@end