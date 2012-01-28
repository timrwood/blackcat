//
//  AHGraphicsSkeleton.m
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsSkeleton.h"

#import "AHGraphicsManager.h"
#import "AHActor.h"
#import "AHGraphicsLimb.h"
#import "AHGraphicsRect.h"


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
#pragma mark setup


- (void)setActor:(AHActor *)actor {
    [super setActor:actor];
    [actor addComponent:_armA];
    [actor addComponent:_armB];
    [actor addComponent:_legA];
    [actor addComponent:_legB];
    [actor addComponent:_head];
    [actor addComponent:_torso];
}


#pragma mark -
#pragma mark sizes


- (void)setFromSkeletonConfig:(AHSkeletonConfig)config {
    // shoulder
    _shoulderPosition.x = 0.0f;
    _shoulderPosition.y = -(config.torsoHeight - config.torsoWidth);
    
    // arms and legs
    [self setLegWidth:config.legWidth];
    [self setLegLength:config.legLength];
    [self setArmWidth:config.armWidth];
    [self setArmLength:config.armLength];
    
    // head and torso
    [_head setRect:CGRectMake(-config.headRight, 
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

- (void)setPosition:(GLKVector2)position {
    _position = position;
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
    return _skeleton;
}


#pragma mark - 
#pragma mark draw


- (void)draw {
    glPushGroupMarkerEXT(0, "Skeleton Draw");
    AHGraphicsManager *m = [AHGraphicsManager manager];
    // set skeleton origin
    
    [m modelMove:GLKVector2Add(_position, GLKVector2Make(_skeleton.x, _skeleton.y))];
    
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
    
    // draw the torso
    [m modelPush];
    
    // push the waist angle
    [m modelRotate:_skeleton.waist];
    [_torso draw];
    
    // draw the head
    [m modelPush];
    [m modelMove:_shoulderPosition 
      thenRotate:_skeleton.neck];
    [_head draw];
    [m modelPop];
    
    // draw the front arm
    [m modelPush];
    [m modelMove:_shoulderPosition 
      thenRotate:_skeleton.shoulderB];
    [_armB draw];
    [m modelPop];
    
    // pop the waist angle
    [m modelPop];
    
    // draw the front leg
    [m modelPush];
    [m modelRotate:_skeleton.hipB];
    [_legB draw];
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


@end







