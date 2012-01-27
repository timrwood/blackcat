//
//  AHPhysicsSkeleton.m
//  BlackCat
//
//  Created by Tim Wood on 1/26/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHMathUtils.h"
#import "AHActor.h"
#import "AHPhysicsRect.h"
#import "AHPhysicsLimb.h"
#import "AHPhysicsRevoluteJoint.h"
#import "AHPhysicsSkeleton.h"


@implementation AHPhysicsSkeleton


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _armA = [[AHPhysicsLimb alloc] init];
        _armB = [[AHPhysicsLimb alloc] init];
        _legA = [[AHPhysicsLimb alloc] init];
        _legB = [[AHPhysicsLimb alloc] init];
        
        _torso = [[AHPhysicsRect alloc] init];
        _head = [[AHPhysicsRect alloc] init];
        
        _neck = [[AHPhysicsRevoluteJoint alloc] init];
        
        // debug
        [_torso setStatic:YES];
        [_head setStatic:YES];
    }
    return self;
}

- (id)initFromSkeleton:(AHSkeleton)skeleton andSkeletonConfig:(AHSkeletonConfig)config {
    _config = config;
    _skeleton = skeleton;
    self = [self init];
    [self setFromSkeletonConfig:_config];
    return self;
}


#pragma mark -
#pragma mark sizes


- (AHSkeleton)skeleton {
    AHSkeleton skeleton;
    skeleton.neck = [_neck rotation];
    skeleton.waist = [_torso rotation] - _skeleton.waist;
    skeleton.shoulderA = [_armA rotationA];
    skeleton.shoulderB = [_armB rotationA];
    skeleton.elbowA = [_armA rotationB];
    skeleton.elbowB = [_armB rotationB];
    skeleton.hipA = [_legA rotationA];
    skeleton.hipB = [_legB rotationA];
    skeleton.kneeA = [_legA rotationB];
    skeleton.kneeB = [_legB rotationB];
    return skeleton;
}

- (void)setFromSkeletonConfig:(AHSkeletonConfig)config {
    // shoulder
    //_shoulderPosition.x = 0.0f;
    //_shoulderPosition.y = config.torsoHeight - config.torsoWidth;
    
    // arms and legs
    [self setLegWidth:config.legWidth];
    [self setLegLength:config.legLength];
    [self setArmWidth:config.armWidth];
    [self setArmLength:config.armLength];
    
    // head and torso
    /*
    [_head setRect:CGRectMake(-config.headLeft, 
                              -config.headTop, 
                              config.headRight + config.headLeft, 
                              config.headBottom + config.headTop)];
    [_torso setRect:CGRectMake(-config.torsoWidth / 2.0f, 
                               - config.torsoWidth / 2.0f, 
                               config.torsoWidth, 
                               config.torsoHeight)];
     */
    
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
    dlog(@"setActor skel");
    
    [actor addComponent:_torso];
    [actor addComponent:_head];
    [actor addComponent:_neck];
    
    [actor addComponent:_armA];
    [actor addComponent:_armB];
    [actor addComponent:_legA];
    [actor addComponent:_legB];
}

- (void)setup {
    dlog(@"setup skel");
    float distanceBetweenWaistAndShoulder = _config.torsoHeight - _config.torsoWidth;
    
    GLKVector2 waistRotationNormalized = GLKVector2Make(-sinf(_skeleton.waist), cosf(_skeleton.waist));
    GLKVector2 waistPosition = GLKVector2Add(_position, GLKVector2Make(_skeleton.x, _skeleton.y));
    
    GLKVector2 waistToShoulder = GLKVector2MultiplyScalar(waistRotationNormalized, distanceBetweenWaistAndShoulder);
    GLKVector2 shoulderPosition = GLKVector2Add(waistPosition, waistToShoulder);
    
    CGSize torsoSize = CGSizeMake(_config.torsoWidth / 2.0f, _config.torsoHeight / 2.0f);
    CGSize headSize = CGSizeMake((_config.headLeft + _config.headRight) / 2.0f, 
                                 (_config.headTop + _config.headBottom) / 2.0f);
    
    GLKVector2 headOffset = GLKVector2Make(headSize.width - _config.headLeft, headSize.height - _config.headBottom);
    GLKVector2 headOffsetRotation = GLKVector2Rotate(headOffset, _skeleton.waist + _skeleton.neck);
    
    GLKVector2 headCenter = GLKVector2Add(shoulderPosition, headOffsetRotation);
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
    [_neck joinBodyA:_torso toBodyB:_head atPosition:shoulderPosition];
    
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


@end
