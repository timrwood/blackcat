//
//  AHPhysicsManagerCPP.h
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "Box2D.h"

#import "AHSubSystem.h"
#import "AHDebugDraw.h"
#import "AHContactListener.h"


@interface AHPhysicsManagerCPP : NSObject <AHSubSystem> {
@private;
    b2World *_world;
    AHDebugDraw *_debugDraw;
    AHContactListener *_contactListener;
}


#pragma mark -
#pragma mark world


- (b2World *)world;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark draw


- (void)drawDebug;


#pragma mark -
#pragma mark query


- (NSMutableArray *)getActorsAtPoint:(GLKVector2)point withSize:(GLKVector2)size;
- (int)getFirstActorCategoryFrom:(GLKVector2)pointA to:(GLKVector2)pointB;
- (int)getFirstActorCategoryWithTag:(int)tag from:(GLKVector2)pointA to:(GLKVector2)pointB;

@end
