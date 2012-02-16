//
//  BCBrokenPolygon.m
//  BlackCat
//
//  Created by Tim Wood on 2/8/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHMathUtils.h"
#import "AHMathQuads.h"
#import "AHPhysicsPolygon.h"

#import "BCGlobalTypes.h"
#import "BCBrokenPolygon.h"


@implementation BCBrokenPolygon


#pragma mark -
#pragma mark init


- (id)initFromQuad:(AHPolygonQuad)quad andTexQuad:(AHPolygonQuad)texQuad andTextureKey:(NSString *)texKey {
    self = [super init];
    if (self) {
        GLKVector2 center = AHPolygonQuadCentroid(quad);
        AHPolygonQuad averagedQuad = AHPolygonQuadSubtractVector(quad, center);
        
        _body = [[AHPhysicsPolygon alloc] initFromPoints:averagedQuad.p andCount:4];
        [_body addTag:PHY_TAG_BREAKABLE];
        [_body setCategory:PHY_CAT_DEBRIS];
        [_body setPosition:center];
        [_body setStatic:NO];
        [self addComponent:_body];
        
        _center = center;
        
        BOOL isHorizontal = YES;
        if (quad.a.x == quad.d.x && quad.b.x == quad.c.x) {
            isHorizontal = NO;
        }
        
        CGRect rect;
        CGRect texRect;
        _skin = [[AHGraphicsCube alloc] init];
        
        rect.origin.x = quad.a.x - center.x;
        rect.origin.y = quad.a.y - center.y;
        rect.size.width = quad.b.x - quad.a.x;
        rect.size.height = quad.d.y - quad.a.y;
        texRect.origin.x = texQuad.a.x;
        texRect.origin.y = texQuad.a.y;
        texRect.size.width = texQuad.b.x - texQuad.a.x;
        texRect.size.height = texQuad.d.y - texQuad.a.y;
        
        if (!isHorizontal) {
            [_skin setRightYTopOffset:quad.b.y - quad.a.y andRightYBottomOffset:quad.c.y - quad.d.y];
        } else {
            [_skin setRightYTopOffset:quad.a.x - quad.d.x andRightYBottomOffset:quad.b.x - quad.c.x];
            [_skin setOffsetHorizontal:YES];
        }
        
        [_skin setRect:rect];
        [_skin setPosition:center];
        [_skin setTex:texRect];
        [_skin setTextureKey:texKey];
        [_skin setStartDepth:Z_PHYSICS_FRONT endDepth:Z_PHYSICS_BACK];
        [self addComponent:_skin];
    }
    return self;
}


#pragma mark -
#pragma mark setters


- (void)setExplosionPoint:(GLKVector2)point andRadius:(float)radius {
    _explosionPoint = point;
    _radius = radius;
}

- (void)setTopTex:(CGRect)topTex andBotTex:(CGRect)botTex {
    [_skin setTopTex:topTex];
    [_skin setBotTex:botTex];
}

- (void)setStartDepth:(float)front endDepth:(float)back {
    [_skin setStartDepth:front endDepth:back];
}


#pragma mark -
#pragma mark setup


- (void)setup {
    [super setup];
    GLKVector2 explosionVelocity = GLKVector2Subtract(_explosionPoint, _center);
    
    // distance to explosion point
    float distanceFromExplosion = GLKVector2Length(explosionVelocity);
    float scalar = (_radius - distanceFromExplosion) * 8.0f;
    
    // normalize and multiply by the scalar
    explosionVelocity = GLKVector2Normalize(explosionVelocity);
    explosionVelocity = GLKVector2MultiplyScalar(explosionVelocity, scalar);
    
    [_body setLinearVelocity:explosionVelocity];
}


#pragma mark -
#pragma mark update


- (void)updateBeforeRender {
    [_skin setPosition:[_body position]];
    [_skin setRotation:[_body rotation]];
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupBeforeDestruction {
    _body = nil;
    _skin = nil;
    
    [super cleanupBeforeDestruction];
}


@end
