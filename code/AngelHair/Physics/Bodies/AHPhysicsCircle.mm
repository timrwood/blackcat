//
//  AHPhysicsCircle.mm
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsCircle.h"


@implementation AHPhysicsCircle


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initFromRadius:(float)radius {
    _radius = radius;
    return [self init];
}

- (id)initFromRadius:(float)radius andPosition:(CGPoint)position {
    _radius = radius;
    _position = position;
    return [self init];
}


#pragma mark -
#pragma mark setup


- (void)setup {
    // shape
	b2CircleShape *circleShape = new b2CircleShape;
	circleShape->m_radius = _radius;
	
	// fixture
	b2FixtureDef *fixtureDef = new b2FixtureDef;
	fixtureDef->density = 1.0f;
    fixtureDef->restitution = self->restitution;
    fixtureDef->restitution = self->friction;
	fixtureDef->shape = (b2Shape *) circleShape;
    fixtureDef->isSensor = self->_isSensor;
	
	// body
	b2BodyDef *bodyDef = new b2BodyDef;
    bodyDef->linearDamping = 0.0f;
    bodyDef->angularDamping = 1.0f;
    bodyDef->fixedRotation = false;
	bodyDef->position = b2Vec2(_position.x, _position.y);
	
    // create body
    [self addBodyToWorld:bodyDef];
    [self addFixtureToBody:fixtureDef];
    
    // cleanup
    delete bodyDef;
    delete fixtureDef;
    delete circleShape;
}


@end
