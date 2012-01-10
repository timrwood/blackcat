//
//  BCPhysics.h
//  BlackCat
//
//  Created by Tim Wood on 11/28/11.
//  Copyright Infinite Beta Games 2011. All rights reserved.
//


#import "AHSubSystem.h"


@class AHPhysicsManagerCPP;


@interface AHPhysicsManager : NSObject <AHSubSystem> {
@private;
    AHPhysicsManagerCPP *_cppManager;
}


#pragma mark -
#pragma mark singleton


+ (AHPhysicsManager *)manager;
+ (AHPhysicsManagerCPP *)cppManager;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark draw


- (void)drawDebug;


@end