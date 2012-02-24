//
//  SKPoseJoint.h
//  Skeletons
//
//  Created by Tim Wood on 2/24/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface SKPoseJoint : NSObject {
@private;
    
}


#pragma mark -
#pragma mark properties


@property (assign) GLKVector2 offsetFromParent;
@property (weak) SKPoseJoint *parent;


@end
