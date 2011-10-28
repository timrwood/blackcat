//
//  BCMaster.h
//  BlackCat
//
//  Created by Tim Wood on 11/28/11.
//  Copyright Infinite Beta Games 2011. All rights reserved.
//


@interface BCMaster : NSObject <BCSubsystem> {
@private
    NSMutableArray *actors;
    NSMutableArray *actorsToAdd;
    NSMutableArray *actorsToDestroy;
}


#pragma mark -
#pragma mark create


- (void)create;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark destroy


- (void)destroy;


#pragma mark -
#pragma mark actors


- (void)add:(BCActor *)actor;
- (void)remove:(BCActor *)actor;
- (void)removeAll;
- (void)destroy:(BCActor *)actor;
- (void)destroyAll;


@end
