//
//  AHGraphicsSkeleton.m
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHGraphicsSkeleton.h"

#import "AHGraphicsManager.h"
#import "AHActor.h"


@implementation AHGraphicsSkeleton


#pragma mark -
#pragma mark init 


- (id)init {
    self = [super init];
    if (self) {
        _armA = [[AHGraphicsLimb alloc] init];
        _armB = [[AHGraphicsLimb alloc] init];
        _legA = [[AHGraphicsLimb alloc] init];
        _legB = [[AHGraphicsLimb alloc] init];
        
        _head = [[AHGraphicsRect alloc] init];
        _torso = [[AHGraphicsRect alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark sizes


- (void)setFromSkeletonConfig:(AHSkeletonConfig)config {
    // shoulder
    _shoulderPosition.y = -(config.torsoHeight - config.torsoWidth);
    
    // neck
    _neckPosition.y = -(config.torsoHeight - config.torsoWidth / 2.0f);
    
    // arms and legs
    [self setLegWidth:config.legWidth];
    [self setLegLength:config.legLength];
    [self setArmWidth:config.armWidth];
    [self setArmLength:config.armLength];
    
    // head and torso
    [_head setRect:CGRectMake(-config.headLeft, 
                              -config.headTop, 
                              config.headRight + config.headLeft, 
                              config.headBottom + config.headTop)];
    [_torso setRect:CGRectMake(-config.torsoWidth / 2.0f, 
                               -config.torsoHeight + config.torsoWidth / 2.0f, 
                               config.torsoWidth, 
                               config.torsoHeight)];
    
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

- (void)setShoulderPosition:(GLKVector2)position {
    _shoulderPosition = position;
}

- (void)setDepth:(float)depth {
    [_armA setDepth:depth - 0.05f];
    [_armB setDepth:depth + 0.1f];
    [_legA setDepth:depth - 0.05f];
    [_legB setDepth:depth + 0.1f];
    [_head setDepth:depth + 0.05f];
    [_torso setDepth:depth];
}


#pragma mark -
#pragma mark texture


- (void)setLegsTextureRect:(CGRect)rect {
    [_legA setTextureRect:rect];
    [_legB setTextureRect:rect];
}

- (void)setLegATextureRect:(CGRect)rect {
    [_legA setTextureRect:rect];
}

- (void)setLegBTextureRect:(CGRect)rect {
    [_legB setTextureRect:rect];
}

- (void)setArmsTextureRect:(CGRect)rect {
    [_armA setTextureRect:rect];
    [_armB setTextureRect:rect];
}

- (void)setArmATextureRect:(CGRect)rect {
    [_armA setTextureRect:rect];
}

- (void)setArmBTextureRect:(CGRect)rect {
    [_armB setTextureRect:rect];
}


#pragma mark -
#pragma mark head torso


- (AHGraphicsRect *)head {
    return _head;
}

- (AHGraphicsRect *)torso {
    return _torso;
}


#pragma mark -
#pragma mark skeleton


- (void)setSkeleton:(AHSkeleton)skeleton {
    _skeleton = skeleton;
}

- (AHSkeleton)skeleton {
    AHSkeleton skel = _skeleton;
    GLKVector2 pos = [self position];
    skel.x += pos.x;
    skel.y += pos.y;
    return skel;
}


#pragma mark -
#pragma mark draw


- (void)draw {
    glPushGroupMarkerEXT(0, "Skeleton Draw");
    AHGraphicsManager *m = [AHGraphicsManager manager];
    // set skeleton origin
    
    [m modelMove:GLKVector2Add(self->_position, GLKVector2Make(_skeleton.x, _skeleton.y))];
    
    // draw the back leg
    [m modelPush];
    [m modelRotate:_skeleton.hipA];
    [_legA draw];
    [m modelPop];
    
    // draw the back arm
    [m modelPush];
    [m modelRotate:_skeleton.waist 
          thenMove:_shoulderPosition 
        thenRotate:_skeleton.shoulderA];
    [_armA draw];
    [m modelPop];
    
    // draw the front leg
    [m modelPush];
    [m modelRotate:_skeleton.hipB];
    [_legB draw];
    [m modelPop];
    
    // push the waist angle
    [m modelPush];
    [m modelRotate:_skeleton.waist];
    
    // draw the head
    [m modelPush];
    [m modelMove:_neckPosition 
      thenRotate:_skeleton.neck];
    [_head draw];
    [m modelPop];
    
    // draw the torso
    [_torso draw];
    
    // draw the front arm
    [m modelPush];
    [m modelMove:_shoulderPosition 
      thenRotate:_skeleton.shoulderB];
    [_armB draw];
    [m modelPop];
    
    // pop the waist angle
    [m modelPop];
    glPopGroupMarkerEXT();
    
    // reset to the identity
    [m modelIdentity];
}


#pragma mark -
#pragma mark update


- (void)update {
    [_armA setAngle:_skeleton.elbowA];
    [_armB setAngle:_skeleton.elbowB];
    [_legA setAngle:_skeleton.kneeA];
    [_legB setAngle:_skeleton.kneeB];
    
    [_armA update];
    [_armB update];
    [_legA update];
    [_legB update];
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval {
    _armB = nil;
    _armA = nil;
    _legA = nil;
    _legB = nil;
    
    _head = nil;
    _torso = nil;
    
    [super cleanupAfterRemoval];
}


@end







