//
//  BCWeaponCannon.h
//  BlackCat
//
//  Created by Tim Wood on 2/14/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHContactDelegate.h"
#import "AHGraphicsCube.h"
#import "AHActor.h"


@class AHPhysicsRect;


@interface BCWeaponCannon : AHActor <AHContactDelegate> {
@private;
    AHGraphicsCube *_skin;
    AHPhysicsRect *_body;
    
    GLKVector2 _velocity;
    
    float _timeCreated;
}


#pragma mark -
#pragma mark init


- (id)initAtPosition:(GLKVector2)position
         andVelocity:(GLKVector2)velocity;


@end
