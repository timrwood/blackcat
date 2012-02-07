//
//  AHPhysicsPill.mm
//  BlackCat
//
//  Created by Tim Wood on 2/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsPill.h"


@implementation AHPhysicsPill


#pragma mark -
#pragma mark setup


- (void)setup {
    // shapes
    b2PolygonShape *polygonShape = new b2PolygonShape;
	b2CircleShape *circleShape = new b2CircleShape;
    b2Vec2 circleOffset;
    
    if (_size.width > _size.height) {
        circleShape->m_radius = _size.height;
        circleOffset = b2Vec2(_size.width - _size.height, 0.0f);
        polygonShape->SetAsBox(_size.width - _size.height, _size.height);
    } else {
        circleShape->m_radius = _size.width;
        circleOffset = b2Vec2(0.0f, _size.height - _size.width);
        polygonShape->SetAsBox(_size.width, _size.height - _size.width);
    }
    
    // fixture
    b2FixtureDef *fixtureDef = new b2FixtureDef;
    fixtureDef->density = 1.0f;
    fixtureDef->restitution = self->restitution;
    fixtureDef->friction = self->friction;
    fixtureDef->shape = (b2Shape *) polygonShape;
    fixtureDef->isSensor = self->isSensor;
    fixtureDef->filter.groupIndex = self->group;
    
    // body
    b2BodyDef *bodyDef = new b2BodyDef;
    bodyDef->angularDamping = .9f;
    bodyDef->position = b2Vec2(_position.x, _position.y);
    bodyDef->angle = _rotation;
    bodyDef->fixedRotation = self->isFixedRotation;
    
    // create body
    [self addBodyToWorld:bodyDef];
    [self addFixtureToBody:fixtureDef];
    
    // add circle a
    circleShape->m_p = circleOffset;
    fixtureDef->shape = (b2Shape *) circleShape;
    [self addFixtureToBody:fixtureDef];
    
    // add circle b
    circleShape->m_p = -circleOffset;
    fixtureDef->shape = (b2Shape *) circleShape;
    [self addFixtureToBody:fixtureDef];
    
    // cleanup
    delete bodyDef;
    delete fixtureDef;
    delete polygonShape;
    delete circleShape;
}


@end