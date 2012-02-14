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
    [self setRadius:radius];
    return [self init];
}

- (id)initFromRadius:(float)radius andPosition:(GLKVector2)position {
    [self setRadius:radius];
    [self setPosition:position];
    return [self init];
}


#pragma mark -
#pragma mark setup


- (void)setup {
    // shape
	b2CircleShape *circleShape = new b2CircleShape;
	circleShape->m_radius = [self radius];
	
	// fixture
	b2FixtureDef *fixtureDef = new b2FixtureDef;
	fixtureDef->shape = (b2Shape *) circleShape;
	
	// body
	b2BodyDef *bodyDef = new b2BodyDef;
	
    // create body
    [self addBodyToWorld:bodyDef];
    [self addFixtureToBody:fixtureDef];
    
    // cleanup
    delete bodyDef;
    delete fixtureDef;
    delete circleShape;
}


@end
