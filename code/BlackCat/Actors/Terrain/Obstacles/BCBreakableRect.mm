//
//  BCBreakableRect.mm
//  BlackCat
//
//  Created by Tim Wood on 2/8/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define OTHER_EDGE_MULTIPLE 1.4f

#define MIN_EDGE_PERCENT 0.05f
#define MIN_SIZE_TO_LEAVE_ALONE 0.5f

#define MIN_PERCENT_TO_LEAVE 0.7f

#define MIN_BLOCK_SIZE 0.1f


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
        
        _skin = [[AHGraphicsCube alloc] init];
        [_skin setRectFromCenter:center andSize:size];
        [_skin setTex:texRect];
        [_skin setTextureKey:texKey];
        [_skin setStartDepth:Z_BUILDING_FRONT endDepth:Z_PHYSICS_FRONT];
        [self addComponent:_skin];
        
        CGRect debugRect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
        [self setTopTex:debugRect andBotTex:debugRect];
        
        // save vars for later
        _texRect = texRect;
        _texKey = texKey;
        _size = size;
        _center = center;
    }
    return self;
}

- (void)setStartDepth:(float)front endDepth:(float)back {
    _frontDepth = front;
    _backDepth = back;
    [_skin setStartDepth:_frontDepth endDepth:_backDepth];
}

- (void)setTopTex:(CGRect)topTex andBotTex:(CGRect)botTex {
    [_skin setTopTex:topTex];
    [_skin setBotTex:botTex];
    _texRectBot = botTex;
    _texRectTop = topTex;
}


#pragma mark -
#pragma mark tags


- (void)addTag:(int)tag {
    [_body addTag:tag];
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupBeforeDestruction {
    _body = nil;
    _skin = nil;
    [super cleanupBeforeDestruction];
}


#pragma mark -
#pragma mark breaking


- (BOOL)isCloseEnoughToBreak {
    if (_hasBroken) {
        return NO;
    }
    
    GLKVector2 distFromCenterToPoint = GLKVector2Subtract(_breakPoint, _center);
    distFromCenterToPoint.x = fabsf(distFromCenterToPoint.x);
    distFromCenterToPoint.y = fabsf(distFromCenterToPoint.y);
    
    GLKVector2 closestCornerToPoint;
    
    // get closest corner x
    if (_center.x > _breakPoint.x) {
        closestCornerToPoint.x = _center.x - _size.width;
    } else {
        closestCornerToPoint.x = _center.x + _size.height;
    }
    
    // get closest corner y
    if (_center.y > _breakPoint.y) {
        closestCornerToPoint.y = _center.y - _size.width;
    } else {
        closestCornerToPoint.y = _center.y + _size.height;
    }
    
    // close enough in width
    if (distFromCenterToPoint.x < _size.width + _breakRadius &&
        distFromCenterToPoint.y < _size.height) {
        dlog(@"close enough in width");
        return YES;
    }
    
    // close enough in height
    if (distFromCenterToPoint.y < _size.height + _breakRadius &&
        distFromCenterToPoint.x < _size.width) {
        dlog(@"close enough in height");
        return YES;
    }
    
    // close enough to corners
    if (GLKVector2Distance(_breakPoint, closestCornerToPoint) < _breakRadius) {
        //dlog(@"too far from corner %@ %@", NSStringFromGLKVector2(_breakPoint), NSStringFromGLKVector2(closestCornerToPoint));
        //dlog(@"too far from corner %@ %@", NSStringFromGLKVector2(_breakPoint), NSStringFromGLKVector2(closestCornerToPoint));
        return YES;
    }
    
    return NO;
}

- (void)breakAtPoint:(GLKVector2)point
          withRadius:(float)radius {
    _breakPoint = point;
    _breakRadius = radius;
    
    if (![self isCloseEnoughToBreak]) {
        return;
    }
    
    if (_size.width > _size.height) {
        [self breakHorizontally];
    } else {
        [self breakVertically];
    }
    [self safeDestroy];
    _hasBroken = YES;
}

- (void)breakHorizontally {
    // get the distance from the point to the wall
    float yDistFromPointToClosestWall = _breakPoint.y - (_center.y - _size.height);
    if (_breakPoint.y > _center.y) {
        yDistFromPointToClosestWall = _breakPoint.y - (_center.y + _size.height);
    }
    
    // get the distance above the point to break
    float xDistAbovePoint = -sqrtf(_breakRadius * _breakRadius - yDistFromPointToClosestWall * yDistFromPointToClosestWall);
    //dlog(@"yDistFromPointToClosestWall %F", yDistFromPointToClosestWall);
    //dlog(@"xDistAbovePoint %F", xDistAbovePoint);
    
    // get the top and bottom break points
    float topBreakLocal = (_breakPoint.x - _center.x) + xDistAbovePoint;
    float botBreakLocal = (_breakPoint.x - _center.x) - xDistAbovePoint;
    //dlog(@"topBreakLocal %F", topBreakLocal);
    //dlog(@"botBreakLocal %F", botBreakLocal);
    
    if (topBreakLocal > -_size.width * MIN_PERCENT_TO_LEAVE) {
        //dlog(@"build a");
        [self buildHorizontalBreakableFromBottom:topBreakLocal toTop:-_size.width];
    } else {
        //dlog(@"too small to build a");
        topBreakLocal = -_size.width;
    }
    if (botBreakLocal < _size.width * MIN_PERCENT_TO_LEAVE) {
        //dlog(@"build b");
        [self buildHorizontalBreakableFromBottom:_size.width toTop:botBreakLocal];
    } else {
        //dlog(@"too small to build b");
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
    
    BCBreakableRect * rect = [[BCBreakableRect alloc] initWithCenter:center
                                                             andSize:size
                                                          andTexRect:texRect
                                                           andTexKey:_texKey];
    [rect setStartDepth:_frontDepth endDepth:_backDepth];
    [rect addTag:[_body tags]];
    [rect enableBreakOnUp:_breakOnUp];
    [rect enableBreakOnRight:_breakOnRight];
    [rect enableBreakOnDown:_breakOnDown];
    [[AHActorManager manager] add:rect];
}

- (void)buildVerticalBrokenFromBottom:(float)bottom toTop:(float)top {
    if (fabsf(bottom - top) < MIN_BLOCK_SIZE) {
        return;
    }
    
    if (top > bottom) {
        //dlog(@"top cannot be bigger than bottom");
        return;
    }
    
    int count = 1;
    if (fabsf(bottom - top) > MIN_SIZE_TO_LEAVE_ALONE) {
        count = 3;
    }
    
    float lefts[count + 1];
    float rights[count + 1];
    
    lefts[0] = top;
    lefts[count] = bottom;
    
    rights[0] = top;
    rights[count] = bottom;
    
    //MIN_EDGE_LENGTH
    
    for (int i = 1; i < count; i++) {
        float aPercent = (float)i / float(count);
        float bPercent = ((aPercent - 0.5f) * OTHER_EDGE_MULTIPLE) + 0.5f;
        bPercent = fminf(1.0f - MIN_EDGE_PERCENT, fmaxf(MIN_EDGE_PERCENT, bPercent));
        //dlog(@"aPercent %F", aPercent);
        //dlog(@"bPercent %F", bPercent);
        if (_breakPoint.x < _center.x) {
            lefts[i] = FloatLerp(top, bottom, aPercent);
            rights[i] = FloatLerp(top, bottom, bPercent);
        } else {
            lefts[i] = FloatLerp(top, bottom, bPercent);
            rights[i] = FloatLerp(top, bottom, aPercent);
        }
        //dlog(@"lefts[%i] %F", i, lefts[i]);
        //dlog(@"rights[%i] %F", i, rights[i]);
    }
    //dlog(@"count %i %F %F", count, top, bottom);
    
    [self buildVerticalBrokenWithLefts:lefts andRights:rights andCount:count];
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
        texQuad.a.x = texRight;
        texQuad.b.x = texLeft;
        texQuad.c.x = texLeft;
        texQuad.d.x = texRight;
        texQuad.a.y = texLefts[i];
        texQuad.b.y = texRights[i];
        texQuad.c.y = texRights[i + 1];
        texQuad.d.y = texLefts[i + 1];
        
        BCBrokenPolygon *poly = [[BCBrokenPolygon alloc] initFromQuad:quad
                                                           andTexQuad:texQuad
                                                        andTextureKey:_texKey];
        [poly setExplosionPoint:_breakPoint andRadius:_breakRadius];
        [[AHActorManager manager] add:poly];
    }
}

#pragma mark -
#pragma mark rebuild horizontal


- (void)buildHorizontalBreakableFromBottom:(float)bottom toTop:(float)top {
    GLKVector2 center = GLKVector2Make(_center.x + FloatLerp(bottom, top, 0.5f), _center.y);
    CGSize size = CGSizeMake((bottom - top) / 2.0f, _size.height);
    
    float topPercent = FloatPercentBetween(-_size.width, _size.width, top);
    float bottomPercent = FloatPercentBetween(-_size.width, _size.width, bottom);
    
    //dlog(@"topPercent %F", topPercent);
    //dlog(@"bottomPercent %F", bottomPercent);
    
    CGRect texRect = _texRect;
    texRect.origin.x = FloatLerp(_texRect.origin.x, _texRect.origin.x + _texRect.size.width, topPercent);
    texRect.size.width = (bottomPercent - topPercent) * _texRect.size.width;
    
    CGRect texRectTop = _texRectTop;
    CGRect texRectBot = _texRectBot;
    
    texRectTop.origin.x = FloatLerp(_texRectTop.origin.x, _texRectTop.origin.x + _texRectTop.size.width, topPercent);
    texRectTop.size.width = (bottomPercent - topPercent) * _texRectTop.size.width;
    
    texRectBot.origin.x = FloatLerp(_texRectBot.origin.x, _texRectBot.origin.x + _texRectBot.size.width, topPercent);
    texRectBot.size.width = (bottomPercent - topPercent) * _texRectBot.size.width;
    
    BCBreakableRect * rect = [[BCBreakableRect alloc] initWithCenter:center
                                                             andSize:size
                                                          andTexRect:texRect
                                                           andTexKey:_texKey];
    [rect setTopTex:texRectTop andBotTex:texRectBot];

    [rect setStartDepth:_frontDepth endDepth:_backDepth];
    [rect addTag:[_body tags]];
    [rect enableBreakOnUp:_breakOnUp];
    [rect enableBreakOnRight:_breakOnRight];
    [rect enableBreakOnDown:_breakOnDown];
    [[AHActorManager manager] add:rect];
}

- (void)buildHorizontalBrokenFromBottom:(float)bottom toTop:(float)top {
    if (fabsf(bottom - top) < MIN_BLOCK_SIZE) {
        return;
    }
    
    if (top > bottom) {
        //dlog(@"top cannot be bigger than bottom");
        return;
    }
    
    int count = 1;
    if (fabsf(bottom - top) > MIN_SIZE_TO_LEAVE_ALONE) {
        count = 3;
    }
    
    float lefts[count + 1];
    float rights[count + 1];
    
    lefts[0] = top;
    lefts[count] = bottom;
    
    rights[0] = top;
    rights[count] = bottom;
    
    //MIN_EDGE_LENGTH
    
    for (int i = 1; i < count; i++) {
        float aPercent = (float)i / float(count);
        float bPercent = (aPercent - 0.5f) * OTHER_EDGE_MULTIPLE + 0.5f;
        bPercent = fminf(1.0f - MIN_EDGE_PERCENT, fmaxf(MIN_EDGE_PERCENT, bPercent));
        //dlog(@"aPercent %F", aPercent);
        //dlog(@"bPercent %F", bPercent);
        if (_breakPoint.y > _center.y) {
            lefts[i] = FloatLerp(top, bottom, aPercent);
            rights[i] = FloatLerp(top, bottom, bPercent);
        } else {
            lefts[i] = FloatLerp(top, bottom, bPercent);
            rights[i] = FloatLerp(top, bottom, aPercent);
        }
        //dlog(@"lefts[%i] %F", i, lefts[i]);
        //dlog(@"rights[%i] %F", i, rights[i]);
    }
    
    [self buildHorizontalBrokenWithLefts:lefts andRights:rights andCount:count];
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
        
        CGRect texRectTop = _texRectTop;
        CGRect texRectBot = _texRectBot;
        
        float percentLeftTop = FloatPercentBetween(-_size.width, _size.width, lefts[i]);
        float percentRightTop = FloatPercentBetween(-_size.width, _size.width, lefts[i + 1]);
        
        texRectTop.origin.x = FloatLerp(_texRectTop.origin.x, _texRectTop.origin.x + _texRectTop.size.width, percentLeftTop);
        texRectTop.size.width = (percentRightTop - percentLeftTop) * _texRectTop.size.width;
        
        texRectBot.origin.x = FloatLerp(_texRectBot.origin.x, _texRectBot.origin.x + _texRectBot.size.width, percentLeftTop);
        texRectBot.size.width = (percentRightTop - percentLeftTop) * _texRectBot.size.width;
        
        BCBrokenPolygon *poly = [[BCBrokenPolygon alloc] initFromQuad:quad
                                                           andTexQuad:texQuad
                                                        andTextureKey:_texKey];
        [poly setTopTex:texRectTop andBotTex:texRectBot];
        [poly setExplosionPoint:_breakPoint andRadius:_breakRadius];
        [[AHActorManager manager] add:poly];
    }
}


#pragma mark -
#pragma mark messages


- (void)enableBreakOnRight:(BOOL)willBreak {
    _breakOnRight = willBreak;
}

- (void)enableBreakOnUp:(BOOL)willBreak {
    _breakOnUp = willBreak;
}

- (void)enableBreakOnDown:(BOOL)willBreak {
    _breakOnDown = willBreak;
}

- (void)recieveMessage:(AHActorMessage *)message {
    BOOL willBreak = NO;
    
    if ([message type] == MSG_EXPLOSION_ALL) {
        willBreak = YES;
    }
    
    if ([message type] == MSG_EXPLOSION_RIGHT && _breakOnRight) {
        willBreak = YES;
    }
    
    if ([message type] == MSG_EXPLOSION_UP && _breakOnUp) {
        willBreak = YES;
    }
    
    if ([message type] == MSG_EXPLOSION_DOWN && _breakOnDown) {
        willBreak = YES;
    }
    
    if (willBreak) {
        GLKVector2 point = [message firstPoint];
        float radius = [message thirdFloat];
        [self breakAtPoint:point withRadius:radius];
    }
}


@end











