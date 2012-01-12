//
//  AHPhysicsSquare.mm
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsRect.h"


@implementation AHPhysicsRect


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initFromSize:(CGSize)size {
    _size = size;
    return [self init];
}

- (id)initFromSize:(CGSize)size andPosition:(CGPoint)position {
    _size = size;
    _position = position;
    return [self init];
}

- (id)initFromSize:(CGSize)size andRotation:(float)rotation {
    _size = size;
    _rotation = rotation;
    return [self init];
}

- (id)initFromSize:(CGSize)size andRotation:(float)rotation andPosition:(CGPoint)position {
    _size = size;
    _rotation = rotation;
    _position = position;
    return [self init];
}


#pragma mark -
#pragma mark setup


- (void)setup {
    // shape
    b2PolygonShape *polygonShape = new b2PolygonShape;
    polygonShape->SetAsBox(_size.width, _size.height);
    
    // fixture
    b2FixtureDef *fixtureDef = new b2FixtureDef;
    fixtureDef->density = 1.0f;
    fixtureDef->restitution = self->restitution;
    fixtureDef->restitution = self->friction;
    fixtureDef->shape = (b2Shape *) polygonShape;
    
    // body
    b2BodyDef *bodyDef = new b2BodyDef;
    bodyDef->angularDamping = .9f;
    bodyDef->position = b2Vec2(_position.x, _position.y);
    bodyDef->angle = _rotation;
    
    // create body
    [self addBodyToWorld:bodyDef];
    [self addFixtureToBody:fixtureDef];
    
    // cleanup
    delete bodyDef;
    delete fixtureDef;
    delete polygonShape;
}


@end
