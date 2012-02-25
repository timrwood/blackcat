//
//  SKPoseView.h
//  Skeletons
//
//  Created by Tim Wood on 2/24/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import <Cocoa/Cocoa.h>


@class SKPoseJoint;


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
    
    float _r;
}


#pragma mark -
#pragma mark init


- (void)initJoints;


#pragma mark -
#pragma mark joints


- (void)addJoint:(SKPoseJoint *)joint;


#pragma mark -
#pragma mark debug


- (void)debugRotation;


@end
