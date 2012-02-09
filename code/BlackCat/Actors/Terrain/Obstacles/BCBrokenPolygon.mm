//
//  BCBrokenPolygon.m
//  BlackCat
//
//  Created by Tim Wood on 2/8/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


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
        [_body setPosition:center];
        [_body setStatic:YES];
        [self addComponent:_body];
        
        _skin = [[AHGraphicsPolygon alloc] initFromPoints:averagedQuad.p andTexPoints:texQuad.p andCount:4];
        [_skin setTextureKey:texKey];
        [_skin setDrawType:GL_TRIANGLE_FAN];
        [self addComponent:_skin];
    }
    return self;
}


#pragma mark -
#pragma mark update


- (void)updateBeforeRender {
    [_skin setPosition:[_body position]];
    [_skin setRotation:[_body rotation]];
}


@end
