//
//  BCPhysics.h
//  BlackCat
//
//  Created by Tim Wood on 11/28/11.
//  Copyright Infinite Beta Games 2011. All rights reserved.
//


#ifdef __cplusplus
    #import "Box2D.h"
#else
    
#endif


#import "AHSubSystem.h"


@interface AHPhysicsManager : NSObject <AHSubSystem> {
@private
#ifdef __cplusplus
    b2World *world;
#endif
    //AHContactListener *contactListener;
}


#pragma mark -
#pragma mark singleton


+ (AHPhysicsManager *)manager;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark bodies


#ifdef __cplusplus
- (b2Body *)addBodyFromDef:(b2BodyDef *)bodyDef;
#endif


@end