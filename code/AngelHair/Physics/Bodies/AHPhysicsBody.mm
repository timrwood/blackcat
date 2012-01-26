//
//  AHPhysicsBody.mm
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsJoint.h"
#import "AHPhysicsBody.h"


@implementation AHPhysicsBody


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _bodyType = b2_dynamicBody;
        restitution = 0.3f;
        _joints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark joints


- (void)addJoint:(AHPhysicsJoint *)joint {
    if ([_joints containsObject:joint]) {
        [_joints addObject:joint];
    }
}

- (void)removeJoint:(AHPhysicsJoint *)joint {
    if ([_joints containsObject:joint]) {
        [_joints removeObject:joint];
    }
}

- (void)removeAllJoints {
    while ([_joints count] > 0) {
        AHPhysicsJoint *joint = (AHPhysicsJoint *)[_joints objectAtIndex:0];
        [joint cleanupAfterRemoval];
    }
}


#pragma mark -
#pragma mark position + rotation


- (GLKVector2)position {
    if (_body) {
        b2Vec2 pos = _body->GetPosition();
        return GLKVector2Make(pos.x, pos.y);
    }
    return GLKVector2Make(0.0f, 0.0f);
}

- (void)setPosition:(GLKVector2)newPosition {
    if (_body) {
        _body->SetTransform(b2Vec2(newPosition.x, newPosition.y), _body->GetAngle());
    }
}

- (float)rotation {
    if (_body) {
        return _body->GetAngle();
    }
    return 0.0f;
}

- (void)setRotation:(float)rotation {
    if (_body) {
        _body->SetTransform(_body->GetPosition(), rotation);
    }
}


#pragma mark -
#pragma mark velocity


- (GLKVector2)force {
    if (_body) {
        float mass = _body->GetMass();
        b2Vec2 vel = _body->GetLinearVelocity();
        vel.Normalize();
        vel *= mass;
        return GLKVector2Make(vel.x, vel.y);
    }
    return GLKVector2Make(0.0f, 0.0f);
}

- (GLKVector2)linearVelocity {
    if (_body) {
        b2Vec2 vel = _body->GetLinearVelocity();
        return GLKVector2Make(vel.x, vel.y);
    }
    return GLKVector2Make(0.0f, 0.0f);
}

- (float)angularVelocity {
    if (_body) {
        return _body->GetAngularVelocity();
    }
    return 0.0f;
}

- (void)setLinearVelocity:(GLKVector2)vel {
    if (_body) {
        _body->SetLinearVelocity(b2Vec2(vel.x, vel.y));
    }
}

- (void)setLinearVelocity:(GLKVector2)vel atWorldPoint:(GLKVector2)point {
    if (_body) {
        _body->ApplyLinearImpulse(b2Vec2(vel.x, vel.y), b2Vec2(point.x, point.y));
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

- (void)setFriction:(float)newFriction {
    friction = newFriction;
}

- (void)setRestitution:(float)newRestitution {
    restitution = newRestitution;
}


#pragma mark -
#pragma mark body


- (b2Body *)body {
    if (!_body) {
        dlog(@"ERROR: Body was not initialized yet!");
    }
    return _body;
}

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

- (void)setSensor:(BOOL)isSensor {
    if (_body) {
        for (b2Fixture *fixture = _body->GetFixtureList(); fixture; fixture = fixture->GetNext()) {
            fixture->SetSensor(isSensor);
        }
    } else {
        _isSensor = isSensor;
    }
}


#pragma mark -
#pragma mark delegate


- (void)setDelegate:(NSObject <AHContactDelegate> *)newDelegate {
    delegate = newDelegate;
}


#pragma mark -
#pragma mark collision


- (BOOL)collidedWith:(AHPhysicsBody *)contact {
    if (delegate && [delegate respondsToSelector:@selector(collidedWith:)]) {
        return [delegate collidedWith:contact];
    }
    return YES;
}

- (BOOL)collidedWithButDidNotCall:(AHPhysicsBody *)contact {
    if (delegate && [delegate respondsToSelector:@selector(collidedWithButDidNotCall:)]) {
        return [delegate collidedWithButDidNotCall:contact];
    }
    return YES;
}

- (BOOL)willCollideWith:(AHPhysicsBody *)contact {
    if (delegate && [delegate respondsToSelector:@selector(willCollideWith:)]) {
        return [delegate willCollideWith:contact];
    }
    return YES;
}

- (BOOL)willCollideWithButWillNotCall:(AHPhysicsBody *)contact {
    if (delegate && [delegate respondsToSelector:@selector(willCollideWithButWillNotCall:)]) {
        return [delegate willCollideWithButWillNotCall:contact];
    }
    return YES;
}

- (BOOL)uncollidedWith:(AHPhysicsBody *)contact {
    if (delegate && [delegate respondsToSelector:@selector(uncollidedWith:)]) {
        return [delegate uncollidedWith:contact];
    }
    return YES;
}

- (BOOL)uncollidedWithButDidNotCall:(AHPhysicsBody *)contact {
    if (delegate && [delegate respondsToSelector:@selector(uncollidedWithButDidNotCall:)]) {
        return [delegate uncollidedWithButDidNotCall:contact];
    }
    return YES;
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval {
    delegate = nil;
    [[AHPhysicsManager cppManager] world]->DestroyBody(_body);
    [self removeAllJoints];
    [super cleanupAfterRemoval];
}


#pragma mark -
#pragma mark tags


- (void)addTag:(int)tag {
    _tags = _tags | tag;
}

- (void)removeTag:(int)tag {
    _tags = _tags ^ tag;
}

- (BOOL)hasTag:(int)tag {
    return (tag & _tags) == tag;
}


#pragma mark -
#pragma mark category


- (void)setCategory:(int)category {
    _category = category;
}

- (int)category {
    return _category;
}


@end
