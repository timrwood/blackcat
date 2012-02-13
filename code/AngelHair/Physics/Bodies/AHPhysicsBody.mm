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
        _restitution = 0.2f;
        _friction = 0.3f;
        _category = 0x0001;
        _group = 0;
        _isFixedRotation = NO;
        _joints = [[NSMutableArray alloc] init];
        _masks = 0xFFFF;
    }
    return self;
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
    } else {
        _position = newPosition;
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

- (void)setFixedRotation:(BOOL)isFixed {
    _isFixedRotation = isFixed;
}


#pragma mark -
#pragma mark velocity


- (void)setBullet:(BOOL)isBullet {
    if (_body) {
        _body->SetBullet(isBullet);
    }
    _isBullet = isBullet;
}

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
    _velocity = b2Vec2(vel.x, vel.y);
    if (_body) {
        _body->SetLinearVelocity(_velocity);
    }
}

- (void)setLinearVelocity:(GLKVector2)vel atWorldPoint:(GLKVector2)point {
    if (_body) {
        _body->ApplyForce(b2Vec2(vel.x, vel.y), b2Vec2(point.x, point.y));
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
    _friction = newFriction;
}

- (void)setRestitution:(float)newRestitution {
    _restitution = newRestitution;
}


#pragma mark -
#pragma mark body


- (b2Body *)body {
    if (!_body) {
        dlog(@"ERROR: Body was not initialized yet!");
    }
    return _body;
}

- (void)addBodyToWorld:(b2BodyDef *)bodyDef {
    bodyDef->linearDamping = 0.0f;
    bodyDef->angularDamping = 1.0f;
    bodyDef->fixedRotation = _isFixedRotation;
	bodyDef->position = b2Vec2(_position.x, _position.y);
    _body = [[AHPhysicsManager cppManager] world]->CreateBody(bodyDef);
    _body->SetUserData((__bridge void *) self);
    _body->SetType(_bodyType);
    _body->SetLinearVelocity(_velocity);
    _body->SetBullet(_isBullet);
}

- (void)addFixtureToBody:(b2FixtureDef *)fixtureDef {
    fixtureDef->density = 1.0f;
    fixtureDef->restitution = _restitution;
    fixtureDef->friction = _friction;
    fixtureDef->isSensor = _isSensor;
    fixtureDef->filter.groupIndex = _group;
    fixtureDef->filter.maskBits = _masks;
    fixtureDef->filter.categoryBits = _category;
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
    [self removeAllJoints];
    if (_body) {
        [[AHPhysicsManager cppManager] world]->DestroyBody(_body);
    }
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

- (void)ignoreCategory:(int)category {
    _masks = _masks ^ category;
}

- (int)category {
    return _category;
}


#pragma mark -
#pragma mark group


- (void)setGroup:(int16)group {
    _group = group;
}


@end
