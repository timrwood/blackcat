//
//  AHPhysicsManagerCPP.h
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "Box2D.h"

#import "AHSubSystem.h"
#import "AHDebugDraw.h"


@interface AHPhysicsManagerCPP : NSObject <AHSubSystem> {
@private;
    b2World *_world;
    AHDebugDraw *_debugDraw;
    // AHContactListener *listener;
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


- (NSMutableArray *)getActorsAtPoint:(CGPoint)point withSize:(CGPoint)size;


@end
