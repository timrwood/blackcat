//
//  BCBreakableRect.mm
//  BlackCat
//
//  Created by Tim Wood on 2/8/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define MIN_PERCENT_TO_LEAVE 0.7f


static BOOL isFirstToBuild = YES;


#import "AHActorManager.h"
#import "AHMathQuads.h"
#import "AHMathUtils.h"
#import "AHPhysicsRect.h"

#import "BCGlobalTypes.h"
#import "BCBrokenPolygon.h"
#import "BCBreakableRect.h"


@implementation BCBreakableRect


#pragma mark -
#pragma mark init


- (id)initWithRect:(CGRect)rect
        andTexRect:(CGRect)texRect
         andTexKey:(NSString *)texKey {
    CGSize size = CGSizeMake(rect.size.width / 2.0f, rect.size.height / 2.0f);
    GLKVector2 position = GLKVector2Make(rect.origin.x + size.width, rect.origin.y + size.height);
    return [self initWithCenter:position andSize:size andTexRect:texRect andTexKey:texKey];
}

- (id)initWithCenter:(GLKVector2)center
             andSize:(CGSize)size
          andTexRect:(CGRect)texRect
           andTexKey:(NSString *)texKey {
    self = [super init];
    if (self) {
        // body
        _body = [[AHPhysicsRect alloc] initFromSize:size andPosition:center];
        [_body addTag:PHY_TAG_BREAKABLE];
        [_body setStatic:YES];
        [self addComponent:_body];
        
        // skin
        _skin = [[AHGraphicsRect alloc] init];
        [_skin setRectFromCenter:center andSize:size];
        [_skin setTex:texRect];
        [_skin setTextureKey:texKey];
        [self addComponent:_skin];
        
        // save vars for later
        _texRect = texRect;
        _texKey = texKey;
        _size = size;
        _center = center;
        
        if (isFirstToBuild) {
            isFirstToBuild = NO;
            // debug
            [self breakAtPoint:GLKVector2Add(center, GLKVector2Make(0.5f, 0.5f)) withRadius:0.5f];
        }
    }
    return self;
}


#pragma mark -
#pragma mark breaking


- (void)breakAtPoint:(GLKVector2)point
          withRadius:(float)radius {
    _breakPoint = point;
    _breakRadius = radius;
    if (_size.width > _size.height) {
        [self breakHorizontally];
    } else {
        [self breakVertically];
    }
    [self safeDestroy];
}

- (void)breakHorizontally {
    // get the distance from the point to the wall
    float yDistFromPointToClosestWall = _breakPoint.y - (_center.y - _size.height);
    if (_breakPoint.y > _center.y) {
        yDistFromPointToClosestWall = _breakPoint.y - (_center.y + _size.height);
    }
    
    // get the distance above the point to break
    float xDistAbovePoint = -sqrtf(_breakRadius * _breakRadius - yDistFromPointToClosestWall * yDistFromPointToClosestWall);
    dlog(@"yDistFromPointToClosestWall %F", yDistFromPointToClosestWall);
    dlog(@"xDistAbovePoint %F", xDistAbovePoint);
    
    // get the top and bottom break points
    float topBreakLocal = (_breakPoint.x - _center.x) + xDistAbovePoint;
    float botBreakLocal = (_breakPoint.x - _center.x) - xDistAbovePoint;
    dlog(@"topBreakLocal %F", topBreakLocal);
    dlog(@"botBreakLocal %F", botBreakLocal);
    
    if (topBreakLocal > -_size.width * MIN_PERCENT_TO_LEAVE) {
        dlog(@"build a");
        [self buildHorizontalBreakableFromBottom:topBreakLocal toTop:-_size.width];
    } else {
        dlog(@"too small to build a");
        topBreakLocal = -_size.width;
    }
    if (botBreakLocal < _size.width * MIN_PERCENT_TO_LEAVE) {
        dlog(@"build b");
        [self buildHorizontalBreakableFromBottom:_size.width toTop:botBreakLocal];
    } else {
        dlog(@"too small to build b");
        botBreakLocal = _size.width;
    }
    [self buildHorizontalBrokenFromBottom:botBreakLocal toTop:topBreakLocal];
}

- (void)breakVertically {
    // get the distance from the point to the wall
    float xDistFromPointToClosestWall = _breakPoint.x - (_center.x - _size.width);
    if (_breakPoint.x > _center.x) {
        xDistFromPointToClosestWall = _breakPoint.x - (_center.x + _size.width);
    }
    
    // get the distance above the point to break
    float yDistAbovePoint = -sqrtf(_breakRadius * _breakRadius - xDistFromPointToClosestWall * xDistFromPointToClosestWall);
    //dlog(@"xDistFromPointToClosestWall %F", xDistFromPointToClosestWall);
    //dlog(@"yDistAbovePoint %F", yDistAbovePoint);
    
    // get the top and bottom break points
    float topBreakLocal = (_breakPoint.y - _center.y) + yDistAbovePoint;
    float botBreakLocal = (_breakPoint.y - _center.y) - yDistAbovePoint;
    //dlog(@"topBreakLocal %F", topBreakLocal);
    //dlog(@"botBreakLocal %F", botBreakLocal);
    
    if (topBreakLocal > -_size.height * MIN_PERCENT_TO_LEAVE) {
        //dlog(@"build a");
        [self buildVerticalBreakableFromBottom:topBreakLocal toTop:-_size.height];
    } else {
        //dlog(@"too small to build a");
        topBreakLocal = -_size.height;
    }
    if (botBreakLocal < _size.height * MIN_PERCENT_TO_LEAVE) {
        //dlog(@"build b");
        [self buildVerticalBreakableFromBottom:_size.height toTop:botBreakLocal];
    } else {
        //dlog(@"too small to build b");
        botBreakLocal = _size.height;
    }
    [self buildVerticalBrokenFromBottom:botBreakLocal toTop:topBreakLocal];
}


#pragma mark -
#pragma mark rebuild vertical


- (void)buildVerticalBreakableFromBottom:(float)bottom toTop:(float)top {
    GLKVector2 center = GLKVector2Make(_center.x, _center.y + FloatLerp(bottom, top, 0.5f));
    CGSize size = CGSizeMake(_size.width, (bottom - top) / 2.0f);
    
    float topPercent = FloatPercentBetween(-_size.height, _size.height, top);
    float bottomPercent = FloatPercentBetween(-_size.height, _size.height, bottom);
    
    //dlog(@"topPercent %F", topPercent);
    //dlog(@"bottomPercent %F", bottomPercent);
    
    CGRect texRect = _texRect;
    texRect.origin.y = FloatLerp(_texRect.origin.y, _texRect.origin.y + _texRect.size.height, topPercent);
    texRect.size.height = (bottomPercent - topPercent) * _texRect.size.height;
    
    
    
    [[AHActorManager manager] add:[[BCBreakableRect alloc] initWithCenter:center
                                                                  andSize:size
                                                               andTexRect:texRect
                                                                andTexKey:_texKey]];
}

- (void)buildVerticalBrokenFromBottom:(float)bottom toTop:(float)top {
    float lefts[5];
    float rights[5];
    
    lefts[0] = top;
    lefts[4] = bottom;
    
    rights[0] = top;
    rights[4] = bottom;
    
    if (_breakPoint.x > _center.x) {
        lefts[1] = FloatLerp(top, bottom, 0.25f);
        lefts[2] = FloatLerp(top, bottom, 0.5f);
        lefts[3] = FloatLerp(top, bottom, 0.75f);
        
        rights[1] = FloatLerp(top, bottom, 0.1f);
        rights[2] = FloatLerp(top, bottom, 0.5f);
        rights[3] = FloatLerp(top, bottom, 0.9f);
    } else {
        lefts[1] = FloatLerp(top, bottom, 0.1f);
        lefts[2] = FloatLerp(top, bottom, 0.5f);
        lefts[3] = FloatLerp(top, bottom, 0.9f);
        
        rights[1] = FloatLerp(top, bottom, 0.25f);
        rights[2] = FloatLerp(top, bottom, 0.5f);
        rights[3] = FloatLerp(top, bottom, 0.75f);
    }
    
    [self buildVerticalBrokenWithLefts:lefts andRights:rights andCount:4];
}

- (void)buildVerticalBrokenWithLefts:(float *)lefts andRights:(float *)rights andCount:(int)count {
    float texMin = _texRect.origin.y;
    float texMax = _texRect.origin.y + _texRect.size.height;
    float texLeft = _texRect.origin.x;
    float texRight = _texRect.origin.x + _texRect.size.width;
    
    float texLefts[count + 1];
    float texRights[count + 1];
    
    for (int i = 0; i < count + 1; i++) {
        float percentLeft = FloatPercentBetween(-_size.height, _size.height, lefts[i]);
        float percentRight = FloatPercentBetween(-_size.height, _size.height, rights[i]);
        texLefts[i] = FloatLerp(texMin, texMax, percentLeft);
        texRights[i] = FloatLerp(texMin, texMax, percentRight);
    }
    
    for (int i = 0; i < count; i++) {
        AHPolygonQuad quad;
        quad.a.x = -_size.width;
        quad.b.x = _size.width;
        quad.c.x = _size.width;
        quad.d.x = -_size.width;
        quad.a.y = lefts[i];
        quad.b.y = rights[i];
        quad.c.y = rights[i + 1];
        quad.d.y = lefts[i + 1];
        quad = AHPolygonQuadAddVector(quad, _center);
        
        AHPolygonQuad texQuad;
        texQuad.a.x = texLeft;
        texQuad.b.x = texRight;
        texQuad.c.x = texRight;
        texQuad.d.x = texLeft;
        texQuad.a.y = texLefts[i];
        texQuad.b.y = texRights[i];
        texQuad.c.y = texRights[i + 1];
        texQuad.d.y = texLefts[i + 1];
        [[AHActorManager manager] add:[[BCBrokenPolygon alloc] initFromQuad:quad
                                                                 andTexQuad:texQuad
                                                              andTextureKey:_texKey]];
    }
}

#pragma mark -
#pragma mark rebuild horizontal


- (void)buildHorizontalBreakableFromBottom:(float)bottom toTop:(float)top {
    GLKVector2 center = GLKVector2Make(_center.x + FloatLerp(bottom, top, 0.5f), _center.y);
    CGSize size = CGSizeMake((bottom - top) / 2.0f, _size.height);
    
    float topPercent = FloatPercentBetween(-_size.width, _size.width, top);
    float bottomPercent = FloatPercentBetween(-_size.width, _size.width, bottom);
    
    dlog(@"topPercent %F", topPercent);
    dlog(@"bottomPercent %F", bottomPercent);
    
    CGRect texRect = _texRect;
    texRect.origin.x = FloatLerp(_texRect.origin.x, _texRect.origin.x + _texRect.size.width, topPercent);
    texRect.size.width = (bottomPercent - topPercent) * _texRect.size.width;
    
    
    
    [[AHActorManager manager] add:[[BCBreakableRect alloc] initWithCenter:center
                                                                  andSize:size
                                                               andTexRect:texRect
                                                                andTexKey:_texKey]];
}

- (void)buildHorizontalBrokenFromBottom:(float)bottom toTop:(float)top {
    float lefts[5];
    float rights[5];
    
    lefts[0] = top;
    lefts[4] = bottom;
    
    rights[0] = top;
    rights[4] = bottom;
    
    if (_breakPoint.y > _center.y) {
        lefts[1] = FloatLerp(top, bottom, 0.25f);
        lefts[2] = FloatLerp(top, bottom, 0.5f);
        lefts[3] = FloatLerp(top, bottom, 0.75f);
        
        rights[1] = FloatLerp(top, bottom, 0.1f);
        rights[2] = FloatLerp(top, bottom, 0.5f);
        rights[3] = FloatLerp(top, bottom, 0.9f);
    } else {
        lefts[1] = FloatLerp(top, bottom, 0.1f);
        lefts[2] = FloatLerp(top, bottom, 0.5f);
        lefts[3] = FloatLerp(top, bottom, 0.9f);
        
        rights[1] = FloatLerp(top, bottom, 0.25f);
        rights[2] = FloatLerp(top, bottom, 0.5f);
        rights[3] = FloatLerp(top, bottom, 0.75f);
    }
    
    [self buildHorizontalBrokenWithLefts:lefts andRights:rights andCount:4];
}

- (void)buildHorizontalBrokenWithLefts:(float *)lefts andRights:(float *)rights andCount:(int)count {
    float texMin = _texRect.origin.x;
    float texMax = _texRect.origin.x + _texRect.size.width;
    float texLeft = _texRect.origin.y;
    float texRight = _texRect.origin.y + _texRect.size.height;
    
    float texLefts[count + 1];
    float texRights[count + 1];
    
    for (int i = 0; i < count + 1; i++) {
        float percentLeft = FloatPercentBetween(-_size.width, _size.width, lefts[i]);
        float percentRight = FloatPercentBetween(-_size.width, _size.width, rights[i]);
        texLefts[i] = FloatLerp(texMin, texMax, percentLeft);
        texRights[i] = FloatLerp(texMin, texMax, percentRight);
    }
    
    for (int i = 0; i < count; i++) {
        AHPolygonQuad quad;
        quad.a.y = -_size.height;
        quad.b.y = -_size.height;
        quad.c.y = _size.height;
        quad.d.y = _size.height;
        quad.a.x = lefts[i];
        quad.b.x = lefts[i + 1];
        quad.c.x = rights[i + 1];
        quad.d.x = rights[i];
        quad = AHPolygonQuadAddVector(quad, _center);
        
        AHPolygonQuad texQuad;
        texQuad.a.y = texLeft;
        texQuad.b.y = texLeft;
        texQuad.c.y = texRight;
        texQuad.d.y = texRight;
        texQuad.a.x = texLefts[i];
        texQuad.b.x = texLefts[i + 1];
        texQuad.c.x = texRights[i + 1];
        texQuad.d.x = texRights[i];
        [[AHActorManager manager] add:[[BCBrokenPolygon alloc] initFromQuad:quad
                                                                 andTexQuad:texQuad
                                                              andTextureKey:_texKey]];
    }
}


@end











