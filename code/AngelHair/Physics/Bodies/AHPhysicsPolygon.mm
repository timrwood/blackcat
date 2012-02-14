//
//  AHPhysicsPolygon.mm
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsPolygon.h"


@implementation AHPhysicsPolygon


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _isLooped = YES;
    }
    return self;
}

- (id)initFromPoints:(GLKVector2 *)points andCount:(int)count {
    return [self initFromPoints:points andCount:count andPosition:GLKVector2Make(0.0f, 0.0f)];
}

- (id)initFromPoints:(GLKVector2 *)points andCount:(int)count andPosition:(GLKVector2)position {
    self = [super init];
    if (self) {
        _isLooped = YES;
        [self setPoints:points andCount:count];
        [self setPosition:position];
    }
    return self;
}


#pragma mark -
#pragma mark setters


- (void)setPoints:(GLKVector2 *)points andCount:(int)count {
    if (_points) {
        free(_points);
    }
    _points = (b2Vec2 *) malloc(sizeof(b2Vec2) * count);
    _count = count;
    for (int i = 0; i < count; i++) {
        _points[i] = b2Vec2(points[i].x, points[i].y);
    }
}

- (void)setLooped:(BOOL)looped {
    _isLooped = looped;
}

- (void)setEdge:(BOOL)edge {
    _isEdge = edge;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    // shape
    b2ChainShape *chainShape = new b2ChainShape;
    b2PolygonShape *polygonShape = new b2PolygonShape;
    if (_isEdge) {
        if (_isLooped) {
            chainShape->CreateLoop(_points, _count);
        } else {
            chainShape->CreateChain(_points, _count);
        }
    } else {
        /*
        for (int i = 0; i < _count; i++) {
            dlog(@"points {%F, %F}", _points[i].x, _points[i].y);
        }
        dlog(@"------ end ----");
         */

        polygonShape->Set(_points, _count);
    }
    
    // radius
    float radius = 0.0f;
    for (int i = 0; i < _count; i++) {
        radius = fmaxf(radius, GLKVector2Length(GLKVector2Make(_points[i].x, _points[i].y)));
    }
    [self setRadius:radius];
    
    // fixture
    b2FixtureDef *fixtureDef = new b2FixtureDef;
    if (_isEdge) {
        fixtureDef->shape = (b2Shape *) chainShape;
    } else {
        fixtureDef->shape = (b2Shape *) polygonShape;
    }
    
    // body
    b2BodyDef *bodyDef = new b2BodyDef;
    
    // create body
    [self addBodyToWorld:bodyDef];
    [self addFixtureToBody:fixtureDef];
    
    // cleanup
    delete bodyDef;
    delete fixtureDef;
    delete chainShape;
    delete polygonShape;
}


@end
