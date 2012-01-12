//
//  AHComponent.h
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


@class AHActor;


@interface AHActorComponent : NSObject {
@private
    AHActor *_actor;
}


#pragma mark -
#pragma mark setup


- (void)setup;


#pragma mark -
#pragma mark actor


- (void)setActor:(AHActor *)actor;
- (void)destroyActor;


#pragma mark -
#pragma mark destroy


- (void)cleanupAfterRemoval;


@end

