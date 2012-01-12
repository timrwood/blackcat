//
//  AHPhysicsRect.h
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsBody.h"


@interface AHPhysicsRect : AHPhysicsBody {
    float _rotation;
    CGSize _size;
    CGPoint _position;
}


#pragma mark -
#pragma mark init


- (id)initFromSize:(CGSize)size;
- (id)initFromSize:(CGSize)size andRotation:(float)rotation;
- (id)initFromSize:(CGSize)size andPosition:(CGPoint)position;
- (id)initFromSize:(CGSize)size andRotation:(float)rotation andPosition:(CGPoint)position;


@end
