//
//  AHGraphicsSkeleton.h
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHSkeletonStruct.h"
#import "AHGraphicsObject.h"
#import "AHGraphicsRect.h"
#import "AHGraphicsLimb.h"


@interface AHGraphicsSkeleton : AHGraphicsObject {
@private;
    AHGraphicsLimb *_armA;
    AHGraphicsLimb *_armB;
    AHGraphicsLimb *_legA;
    AHGraphicsLimb *_legB;
    
    AHGraphicsRect *_head;
    AHGraphicsRect *_torso;
    
    GLKVector2 _shoulderPosition;
    GLKVector2 _neckPosition;

    AHSkeleton _skeleton;
    
    AHSkeletonConfig _config;
}


#pragma mark -
#pragma mark sizes


- (void)setFromSkeletonConfig:(AHSkeletonConfig)config;
- (AHSkeletonConfig)skeletonConfig;
- (void)setLegWidth:(float)width;
- (void)setLegLength:(float)length;
- (void)setArmWidth:(float)width;
- (void)setArmLength:(float)length;
- (void)setShoulderPosition:(GLKVector2)position;
- (void)setDepth:(float)depth;


#pragma mark -
#pragma mark texture


- (void)setLegsTextureRect:(CGRect)rect;
- (void)setLegATextureRect:(CGRect)rect;
- (void)setLegBTextureRect:(CGRect)rect;
- (void)setArmsTextureRect:(CGRect)rect;
- (void)setArmATextureRect:(CGRect)rect;
- (void)setArmBTextureRect:(CGRect)rect;


#pragma mark -
#pragma mark head torso


- (AHGraphicsRect *)head;
- (AHGraphicsRect *)torso;


#pragma mark - 
#pragma mark skeleton


- (void)setSkeleton:(AHSkeleton)skeleton;
- (AHSkeleton)skeleton;


@end
