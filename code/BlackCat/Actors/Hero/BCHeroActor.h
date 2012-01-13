//
//  BCHeroActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActor.h"
#import "AHInputComponent.h"
#import "AHContactDelegate.h"


@class AHPhysicsCircle;


@interface BCHeroActor : AHActor <AHInputDelegate, AHContactDelegate> {
@private;
    AHPhysicsCircle *_body;
    AHInputComponent *_input;
    
    BOOL _canJump;
    
    float _runSpeed;
}


#pragma mark -
#pragma mark camera


- (void)updateCamera;


@end
