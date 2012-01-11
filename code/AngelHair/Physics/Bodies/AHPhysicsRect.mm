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


- (id)initFromSize:(CGPoint)size {
    return [self initFromSize:size andRotation:0.0f andPosition:CGPointMake(0.0f, 0.0f)];
}

- (id)initFromSize:(CGPoint)size andRotation:(float)rotation {
    return [self initFromSize:size andRotation:rotation andPosition:CGPointMake(0.0f, 0.0f)];
}

- (id)initFromSize:(CGPoint)size andRotation:(float)rotation andPosition:(CGPoint)position {
    self = [super init];
    if (self) {
        // shape
        b2PolygonShape *polygonShape = new b2PolygonShape;
        polygonShape->SetAsBox(size.x, size.y);
        
        // fixture
        b2FixtureDef *fixtureDef = new b2FixtureDef;
        fixtureDef->density = 1.0f;
        fixtureDef->restitution = 0.4f;
        fixtureDef->friction = 0.3f;
        fixtureDef->shape = (b2Shape *) polygonShape;
        
        // body
        b2BodyDef *bodyDef = new b2BodyDef;
        bodyDef->angularDamping = .9f;
        bodyDef->position = b2Vec2(position.x, position.y);
        bodyDef->angle = rotation;
        
        // create body
        [self addBodyToWorld:bodyDef];
        [self addFixtureToBody:fixtureDef];
        
        // cleanup
        delete bodyDef;
        delete fixtureDef;
        delete polygonShape;
    }
    return self;
}


@end
