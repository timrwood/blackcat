//
//  SKPoseView.m
//  Skeletons
//
//  Created by Tim Wood on 2/24/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "SKPoseJoint.h"
#import "SKPoseView.h"


@implementation SKPoseView


#pragma mark -
#pragma mark init


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        joints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initJoints {
    waist = [[SKPoseJoint alloc] init];
    neck = [[SKPoseJoint alloc] init];
    
    elbow1 = [[SKPoseJoint alloc] init];
    elbow2 = [[SKPoseJoint alloc] init];
    
    shoulder1 = [[SKPoseJoint alloc] init];
    shoulder2 = [[SKPoseJoint alloc] init];
    
    knee1 = [[SKPoseJoint alloc] init];
    knee2 = [[SKPoseJoint alloc] init];
    
    hip1 = [[SKPoseJoint alloc] init];
    hip2 = [[SKPoseJoint alloc] init];
    
    [self addJoint:waist];
    [self addJoint:neck];
    
    [self addJoint:elbow1];
    [self addJoint:elbow2];
    
    [self addJoint:shoulder1];
    [self addJoint:shoulder2];
    
    [self addJoint:knee1];
    [self addJoint:knee2];
    
    [self addJoint:hip1];
    [self addJoint:hip2];
    
    [neck setParent:waist];
    
    [elbow1 setParent:shoulder1];
    [elbow2 setParent:shoulder2];
    
    [shoulder1 setParent:waist];
    [shoulder2 setParent:waist];
    
    [hip1 setParent:waist];
    [hip2 setParent:waist];
    
    [knee1 setParent:hip1];
    [knee2 setParent:hip2];
}


#pragma mark -
#pragma mark draw


- (void)drawRect:(NSRect)dirtyRect {
    
}


#pragma mark -
#pragma mark joints


- (void)addJoint:(SKPoseJoint *)joint {
    if (![joints containsObject:joint]) {
        [joints addObject:joint];
    }
}


@end
