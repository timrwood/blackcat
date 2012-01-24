//
//  BCCrateActor.mm
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define CRATE_SIZE 0.2f


#import "AHPhysicsRect.h"

#import "BCGlobalTypes.h"
#import "BCCrateActor.h"


@implementation BCCrateActor


#pragma mark -
#pragma mark init


- (id)initAtPosition:(GLKVector2)position {
    self = [super init];
    if (self) {
        _body = [[AHPhysicsRect alloc] initFromSize:CGSizeMake(CRATE_SIZE, CRATE_SIZE) andPosition:position];
        [_body setStatic:NO];
        [_body addTag:PHY_TAG_DEBRIS];
        [_body setDelegate:self];
        [self addComponent:_body];
    }
    return self;
}


#pragma mark -
#pragma mark contacts


- (BOOL)willCollideWith:(AHPhysicsBody *)contact {
    if ([contact category] == PHY_CAT_HERO) {
        if (!_hasBeenUpset) {
            GLKVector2 force = [contact force];
            force.x *= 2.0f;
            force.y *= 2.0f;
            [_body setLinearVelocity:force atWorldPoint:[contact position]];
            _hasBeenUpset = YES;
        }
        return NO;
    }
    return YES;
}


#pragma mark -
#pragma mark static vars


+ (float)size {
    return CRATE_SIZE;
}


@end
