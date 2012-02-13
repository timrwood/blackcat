//
//  BCBrokenPolygon.m
//  BlackCat
//
//  Created by Tim Wood on 2/8/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


//static int wasStatic = 0;


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
        /*
        if (wasStatic > 2) {
            [_body setStatic:YES];
        } else {
            [_body setStatic:NO];
        }
        wasStatic = (wasStatic + 1) % 6;
         */
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
        
        if (!isHorizontal) {
            rect.origin.x = quad.a.x - center.x;
            rect.origin.y = quad.a.y - center.y;
            rect.size.width = quad.b.x - quad.a.x;
            rect.size.height = quad.d.y - quad.a.y;
            texRect.origin.x = texQuad.a.x;
            texRect.origin.y = texQuad.a.y;
            texRect.size.width = texQuad.b.x - texQuad.a.x;
            texRect.size.height = texQuad.d.y - texQuad.a.y;
            [_skin setRightYTopOffset:quad.b.y - quad.a.y andRightYBottomOffset:quad.c.y - quad.d.y];
        } else {
            _rotationAddition = M_TAU_4;
            [_skin setRotation:_rotationAddition];
            rect.origin.x = quad.a.y - center.y;
            rect.origin.y = quad.a.x - center.x;
            rect.size.width = quad.d.y - quad.a.y;
            rect.size.height = quad.b.x - quad.a.x;
            texRect.origin.x = texQuad.a.y;
            texRect.origin.y = texQuad.a.x;
            texRect.size.width = texQuad.d.y - texQuad.a.y;
            texRect.size.height = texQuad.b.x - texQuad.a.x;
            [_skin setRightYTopOffset:quad.b.x - quad.c.x andRightYBottomOffset:quad.a.x - quad.d.x];
        }
        
        [_skin setRect:rect];
        [_skin setTex:texRect];
        [_skin setTopTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skin setBotTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skin setTextureKey:texKey];
        [_skin setStartDepth:Z_PHYSICS_FRONT endDepth:Z_PHYSICS_BACK];
        [self addComponent:_skin];
    }
    return self;
}


#pragma mark -
#pragma mark setters


- (void)setExplosionPoint:(GLKVector2)point {
    _explosionPoint = point;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    [super setup];
    GLKVector2 explosionVelocity = GLKVector2Subtract(_center, _explosionPoint);
    explosionVelocity = GLKVector2MultiplyScalar(explosionVelocity, 3.0f);
    //dlog(@"velocity %@", NSStringFromGLKVector2(explosionVelocity));
    [_body setLinearVelocity:explosionVelocity];
    //[_body setLinearVelocity:explosionVelocity atWorldPoint:_explosionPoint];
}


#pragma mark -
#pragma mark update


- (void)updateBeforeRender {
    [_skin setPosition:[_body position]];
    [_skin setRotation:[_body rotation] + _rotationAddition];
}


@end
