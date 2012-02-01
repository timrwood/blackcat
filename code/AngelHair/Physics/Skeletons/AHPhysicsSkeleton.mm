//
//  AHPhysicsSkeleton.m
//  BlackCat
//
//  Created by Tim Wood on 1/26/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


static int SKELETON_OFFSET = 0;


#import "AHMathUtils.h"
#import "AHActor.h"
#import "AHPhysicsRect.h"
#import "AHPhysicsLimb.h"
#import "AHPhysicsRevoluteJoint.h"
#import "AHPhysicsSkeleton.h"


@implementation AHPhysicsSkeleton


#pragma mark -
#pragma mark init


- (id)initFromSkeleton:(AHSkeleton)skeleton andSkeletonConfig:(AHSkeletonConfig)config {
    self = [super init];
    if (self) {
        _armA = [[AHPhysicsLimb alloc] init];
        _armB = [[AHPhysicsLimb alloc] init];
        _legA = [[AHPhysicsLimb alloc] init];
        _legB = [[AHPhysicsLimb alloc] init];
        
        _torso = [[AHPhysicsRect alloc] init];
        _head = [[AHPhysicsRect alloc] init];
        
        _neck = [[AHPhysicsRevoluteJoint alloc] init];
        
        // config and skeleton
        [self setFromSkeletonConfig:config];
        _skeleton = skeleton;
        
        SKELETON_OFFSET--;
        [_armA setGroup:SKELETON_OFFSET];
        [_armB setGroup:SKELETON_OFFSET];
        [_legA setGroup:SKELETON_OFFSET];
        [_legB setGroup:SKELETON_OFFSET];
        
        [_torso setGroup:SKELETON_OFFSET];
        [_head setGroup:SKELETON_OFFSET];
    }
    return self;
}


#pragma mark -
#pragma mark limits


- (void)setUpperLimits:(AHSkeleton)upper 
        andLowerLimits:(AHSkeleton)lower {
    [_armA setLimitAUpper:upper.shoulderA lower:lower.shoulderA];
    [_armB setLimitAUpper:upper.shoulderB lower:lower.shoulderB];
    [_armA setLimitBUpper:upper.elbowA lower:lower.elbowA];
    [_armB setLimitBUpper:upper.elbowB lower:lower.elbowB];
    [_legA setLimitAUpper:upper.hipA lower:lower.hipA];
    [_legB setLimitAUpper:upper.hipB lower:lower.hipB];
    [_legA setLimitBUpper:upper.kneeA lower:lower.kneeA];
    [_legB setLimitBUpper:upper.kneeB lower:lower.kneeB];
    [_neck setUpperLimit:upper.neck];
    [_neck setLowerLimit:lower.neck];
}


#pragma mark -
#pragma mark sizes


- (AHSkeleton)skeleton {
    AHSkeleton skeleton;
    skeleton.neck = [_head rotation] - [_torso rotation];
    skeleton.waist = [_torso rotation];
    skeleton.shoulderA = [_armA rotationA] - [_torso rotation];
    skeleton.shoulderB = [_armB rotationA] - [_torso rotation];
    skeleton.elbowA = [_armA rotationB];
    skeleton.elbowB = [_armB rotationB];
    skeleton.hipA = [_legA rotationA];
    skeleton.hipB = [_legB rotationA];
    skeleton.kneeA = [_legA rotationB];
    skeleton.kneeB = [_legB rotationB];
    
    float distanceBetweenCenterAndWaist = -(_config.torsoHeight - _config.torsoWidth) / 2.0f;
    GLKVector2 position = GLKVector2MakeFromRotationAndLength(skeleton.waist - M_TAU_4, distanceBetweenCenterAndWaist);
    position = GLKVector2Add([_torso position], position);
    
    skeleton.x = position.x;
    skeleton.y = position.y;
    return skeleton;
}

- (void)setFromSkeletonConfig:(AHSkeletonConfig)config {
    // arms and legs
    [self setLegWidth:config.legWidth];
    [self setLegLength:config.legLength];
    [self setArmWidth:config.armWidth];
    [self setArmLength:config.armLength];
    
    // assign for later retrival
    _config = config;
}

- (AHSkeletonConfig)skeletonConfig {
    return _config;
}

- (void)setLegWidth:(float)width {
    [_legA setWidth:width];
    [_legB setWidth:width];
}

- (void)setLegLength:(float)length {
    [_legA setLength:length];
    [_legB setLength:length];
}

- (void)setArmWidth:(float)width {
    [_armA setWidth:width];
    [_armB setWidth:width];
}

- (void)setArmLength:(float)length {
    [_armA setLength:length];
    [_armB setLength:length];
}

- (void)setPosition:(GLKVector2)position {
    _position = position;
}


#pragma mark -
#pragma mark setup


- (void)setActor:(AHActor *)actor {
    [super setActor:actor];
    
    [actor addComponent:_torso];
    [actor addComponent:_head];
    [actor addComponent:_neck];
    
    [actor addComponent:_armA];
    [actor addComponent:_armB];
    [actor addComponent:_legA];
    [actor addComponent:_legB];
}

- (void)setup {
    float distanceBetweenWaistAndShoulder = _config.torsoHeight - _config.torsoWidth;
    float distanceBetweenWaistAndNeck = _config.torsoHeight - (_config.torsoWidth / 2.0f);
    
    GLKVector2 waistRotationNormalized = GLKVector2Make(sinf(_skeleton.waist), -cosf(_skeleton.waist));
    GLKVector2 waistPosition = GLKVector2Add(_position, GLKVector2Make(_skeleton.x, _skeleton.y));
    
    GLKVector2 waistToShoulder = GLKVector2MultiplyScalar(waistRotationNormalized, distanceBetweenWaistAndShoulder);
    GLKVector2 shoulderPosition = GLKVector2Add(waistPosition, waistToShoulder);
    
    GLKVector2 waistToNeck = GLKVector2MultiplyScalar(waistRotationNormalized, distanceBetweenWaistAndNeck);
    GLKVector2 neckPosition = GLKVector2Add(waistPosition, waistToNeck);
    
    CGSize torsoSize = CGSizeMake(_config.torsoWidth / 2.0f, _config.torsoHeight / 2.0f);
    CGSize headSize = CGSizeMake((_config.headLeft + _config.headRight) / 2.0f, 
                                 (_config.headTop + _config.headBottom) / 2.0f);
    
    GLKVector2 headOffset = GLKVector2Make(-(headSize.width - _config.headRight), -(headSize.height - _config.headBottom));
    GLKVector2 headOffsetRotation = GLKVector2Rotate(headOffset, _skeleton.waist + _skeleton.neck);
    
    GLKVector2 headCenter = GLKVector2Add(neckPosition, headOffsetRotation);
    GLKVector2 torsoCenter = GLKVector2Add(waistPosition, GLKVector2MultiplyScalar(waistToShoulder, 0.5f));
    
    [_torso setSize:torsoSize andRotation:_skeleton.waist andPosition:torsoCenter];
    [_head setSize:headSize andRotation:_skeleton.waist + _skeleton.neck andPosition:headCenter];
    
    // rotations
    [_armA setRotation:_skeleton.waist + _skeleton.shoulderA];
    [_armB setRotation:_skeleton.waist + _skeleton.shoulderB];
    [_legA setRotation:_skeleton.hipA];
    [_legB setRotation:_skeleton.hipB];
    
    // angles
    [_armA setAngle:_skeleton.elbowA];
    [_armB setAngle:_skeleton.elbowB];
    [_legA setAngle:_skeleton.kneeA];
    [_legB setAngle:_skeleton.kneeB];
    
    // positions
    [_armA setPosition:shoulderPosition];
    [_armB setPosition:shoulderPosition];
    [_legA setPosition:waistPosition];
    [_legB setPosition:waistPosition];
    [_neck joinBodyA:_torso toBodyB:_head atPosition:neckPosition];
    
    [_armA attachToBody:_torso];
    [_armB attachToBody:_torso];
    [_legA attachToBody:_torso];
    [_legB attachToBody:_torso];
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval {
    _armA = nil;
    _armB = nil;
    _legA = nil;
    _legB = nil;
    _torso = nil;
    _head = nil;
    _neck = nil;
}


#pragma mark -
#pragma mark velocity


- (void)setLinearVelocity:(GLKVector2)velocity {
    [_head setLinearVelocity:GLKVector2MultiplyScalar(velocity, 0.9f)];
    [_torso setLinearVelocity:velocity];
    [_armA setLinearVelocity:GLKVector2MultiplyScalar(velocity, 0.9f)];
    [_armB setLinearVelocity:GLKVector2MultiplyScalar(velocity, 0.8f)];
    [_legA setLinearVelocity:GLKVector2MultiplyScalar(velocity, 0.9f)];
    [_legB setLinearVelocity:GLKVector2MultiplyScalar(velocity, 0.8f)];
}


@end
