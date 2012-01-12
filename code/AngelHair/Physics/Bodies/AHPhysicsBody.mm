//
//  AHPhysicsBody.mm
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsBody.h"


@implementation AHPhysicsBody


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _bodyType = b2_dynamicBody;
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark vars


- (CGPoint)position {
    if (_body) {
        b2Vec2 pos = _body->GetPosition();
        return CGPointMake(pos.x, pos.y);
    }
    return CGPointMake(0.0f, 0.0f);
}

- (float)rotation {
    if (_body) {
        return _body->GetAngle();
    }
    return 0.0f;
}

- (CGPoint)linearVelocity {
    if (_body) {
        b2Vec2 vel = _body->GetLinearVelocity();
        return CGPointMake(vel.x, vel.y);
    }
    return CGPointMake(0.0f, 0.0f);
}

- (float)angularVelocity {
    if (_body) {
        return _body->GetAngularVelocity();
    }
    return 0.0f;
}

- (void)setLinearVelocity:(CGPoint)vel {
    if (_body) {
        _body->SetLinearVelocity(b2Vec2(vel.x, vel.y));
    }
}

- (void)setAngularVelocity:(float)vel {
    if (_body) {
        _body->SetAngularVelocity(vel);
    }
}


#pragma mark -
#pragma mark setup


- (void)setup {
    
}


#pragma mark -
#pragma mark body


- (void)addBodyToWorld:(const b2BodyDef *)bodyDef {
    _body = [[AHPhysicsManager cppManager] world]->CreateBody(bodyDef);
    _body->SetUserData((__bridge void *) self);
    _body->SetType(_bodyType);
}

- (void)addFixtureToBody:(const b2FixtureDef *)fixtureDef {
    _body->CreateFixture(fixtureDef);
}

- (void)setStatic:(BOOL)isStatic {
    if (_body) {
        if (isStatic) {
            _body->SetType(b2_staticBody);
        } else {
            _body->SetType(b2_dynamicBody);
        }
    } else {
        if (isStatic) {
            _bodyType = b2_staticBody;
        } else {
            _bodyType = b2_dynamicBody;
        }
    }
}


#pragma mark -
#pragma mark delegate


- (void)setDelegate:(NSObject <AHContactDelegate> *)newDelegate {
    if ([newDelegate conformsToProtocol:@protocol(AHContactDelegate)]) {
        delegate = newDelegate;
    }
}


#pragma mark -
#pragma mark collision


- (BOOL)collidedWith:(AHPhysicsBody *)contact {
    if (delegate) {
        return [delegate collidedWith:contact];
    }
    return YES;
}

- (BOOL)collidedWithButDidNotCall:(AHPhysicsBody *)contact {
    if (delegate) {
        return [delegate collidedWithButDidNotCall:contact];
    }
    return YES;
}

- (BOOL)uncollidedWith:(AHPhysicsBody *)contact {
    if (delegate) {
        return [delegate uncollidedWith:contact];
    }
    return YES;
}

- (BOOL)uncollidedWithButDidNotCall:(AHPhysicsBody *)contact {
    if (delegate) {
        return [delegate uncollidedWithButDidNotCall:contact];
    }
    return YES;
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval {
    [[AHPhysicsManager cppManager] world]->DestroyBody(_body);
}


@end
