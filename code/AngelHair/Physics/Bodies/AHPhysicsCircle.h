//
//  AHPhysicsCircle.h
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsBody.h"


@interface AHPhysicsCircle : AHPhysicsBody {
    float _radius;
    GLKVector2 _position;
}


#pragma mark -
#pragma mark init


- (id)initFromRadius:(float)radius;
- (id)initFromRadius:(float)radius andPosition:(GLKVector2)position;


@end
