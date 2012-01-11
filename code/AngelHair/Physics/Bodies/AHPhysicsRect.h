//
//  AHPhysicsRect.h
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsBody.h"


@interface AHPhysicsRect : AHPhysicsBody {
    
}


#pragma mark -
#pragma mark init


- (id)initFromSize:(CGPoint)size;
- (id)initFromSize:(CGPoint)size andRotation:(float)rotation;
- (id)initFromSize:(CGPoint)size andRotation:(float)rotation andPosition:(CGPoint)position;


@end
