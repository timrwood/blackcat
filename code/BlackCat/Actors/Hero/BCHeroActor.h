//
//  BCHeroActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActor.h"
#import "AHInputManager.h"
#import "AHInputComponent.h"


@class AHPhysicsCircle;


@interface BCHeroActor : AHActor <AHInputDelegate> {
@private;
    AHPhysicsCircle *_body;
    AHInputComponent *_input;
}


@end
