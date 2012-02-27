//
//  SKPoseView.h
//  Skeletons
//
//  Created by Tim Wood on 2/24/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHSkeletonStruct.h"
#import <Cocoa/Cocoa.h>


@class SKPoseJoint;
@class SKTimeline;


@interface SKPoseView : NSView {
    NSMutableArray *joints;
    
    SKPoseJoint *waist;
    SKPoseJoint *neck;
    
    SKPoseJoint *elbow1;
    SKPoseJoint *elbow2;
    
    SKPoseJoint *shoulder1;
    SKPoseJoint *shoulder2;
    
    SKPoseJoint *knee1;
    SKPoseJoint *knee2;
    
    SKPoseJoint *hip1;
    SKPoseJoint *hip2;
    
    SKPoseJoint *current;
    
    float _r;
}


#pragma mark -
#pragma mark init


- (void)initJoints;
- (void)jointClosestToPoint:(GLKVector2)point;


#pragma mark -
#pragma mark properties


@property (weak) SKTimeline *timeline;


#pragma mark -
#pragma mark joints


- (void)addJoint:(SKPoseJoint *)joint;


#pragma mark -
#pragma mark debug


- (void)debugRotation;


#pragma mark -
#pragma mark skeleton


- (AHSkeleton)skeleton;
- (void)setSkeleton:(AHSkeleton)skeleton;


@end
