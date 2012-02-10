//
//  AHPhysicsRect.h
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsBody.h"


@interface AHPhysicsRect : AHPhysicsBody {
@protected;
    float _rotation;
    CGSize _size;
}


#pragma mark -
#pragma mark init


- (id)initFromSize:(CGSize)size;
- (id)initFromSize:(CGSize)size andRotation:(float)rotation;
- (id)initFromSize:(CGSize)size andPosition:(GLKVector2)position;
- (id)initFromSize:(CGSize)size andRotation:(float)rotation andPosition:(GLKVector2)position;


#pragma mark -
#pragma mark setters


- (void)setSize:(CGSize)size;
- (void)setSize:(CGSize)size andRotation:(float)rotation;
- (void)setSize:(CGSize)size andPosition:(GLKVector2)position;
- (void)setSize:(CGSize)size andRotation:(float)rotation andPosition:(GLKVector2)position;


@end
