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
    GLKVector2 _originPoint;
    GLKVector2 _endPoint;
    
    float _rotation;
}


#pragma mark -
#pragma mark properties



@property (assign, nonatomic) GLKVector2 position;
@property (assign) GLKVector2 length;
@property (weak) SKPoseJoint *parent;


#pragma mark -
#pragma mark rotation


- (GLKVector2)rotatePoint:(GLKVector2)point
                  radians:(float)radians;
- (void)setRotation:(float)rotation;
- (float)rotation;
- (GLKVector2)endPoint;
- (void)rotateTowardsPoint:(GLKVector2)point;


#pragma mark -
#pragma mark position


- (void)updatePosition;


#pragma mark -
#pragma mark draw


- (void)drawInContext:(CGContextRef)c;


@end
