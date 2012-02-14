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


- (id)initFromSize:(CGSize)size {
    self = [super init];
    if (self) {
        _size = size;
    }
    return self;
}

- (id)initFromSize:(CGSize)size andPosition:(GLKVector2)position {
    self = [super init];
    if (self) {
        _size = size;
        [self setPosition:position];
    }
    return self;
}

- (id)initFromSize:(CGSize)size andRotation:(float)rotation {
    self = [super init];
    if (self) {
        _size = size;
        [self setRotation:rotation];
    }
    return self;
}

- (id)initFromSize:(CGSize)size andRotation:(float)rotation andPosition:(GLKVector2)position {
    self = [super init];
    if (self) {
        _size = size;
        [self setRotation:rotation];
        [self setPosition:position];
    }
    return self;
}


#pragma mark -
#pragma mark setters


- (void)setSize:(CGSize)size {
    _size = size;
}

- (void)setSize:(CGSize)size andPosition:(GLKVector2)position {
    _size = size;
    [self setPosition:position];
}

- (void)setSize:(CGSize)size andRotation:(float)rotation {
    _size = size;
    [self setRotation:rotation];
}

- (void)setSize:(CGSize)size andRotation:(float)rotation andPosition:(GLKVector2)position {
    _size = size;
    [self setRotation:rotation];
    [self setPosition:position];
}


#pragma mark -
#pragma mark setup


- (void)setup {
    float radius = GLKVector2Length(GLKVector2Make(_size.width, _size.height));
    [self setRadius:radius];
    
    // shape
    b2PolygonShape *polygonShape = new b2PolygonShape;
    polygonShape->SetAsBox(_size.width, _size.height);
    
    // fixture
    b2FixtureDef *fixtureDef = new b2FixtureDef;
    fixtureDef->shape = (b2Shape *) polygonShape;
    
    // body
    b2BodyDef *bodyDef = new b2BodyDef;
    
    // create body
    [self addBodyToWorld:bodyDef];
    [self addFixtureToBody:fixtureDef];
    
    // cleanup
    delete bodyDef;
    delete fixtureDef;
    delete polygonShape;
}


@end
