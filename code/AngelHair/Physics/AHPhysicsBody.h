//
//  AHPhysicsBody.h
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "AHActorComponent.h"


class b2Body;


@interface AHPhysicsBody : NSObject <AHActorComponent> {
    b2Body *body;
}

@end
