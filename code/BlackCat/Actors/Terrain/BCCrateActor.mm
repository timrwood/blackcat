//
//  BCCrateActor.mm
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define CRATE_SIZE 0.2f


#import "AHGraphicsManager.h"
#import "AHGraphicsRect.h"
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
        
        _skin = [[AHGraphicsRect alloc] init];
        [_skin setRectFromCenter:GLKVector2Make(0.0f, 0.0f) andRadius:CRATE_SIZE];
        [_skin setTextureKey:@"debug-grid.png"];
        [_skin setTexFromCenter:GLKVector2Make(0.5f, 0.5f) andRadius:0.5f];
        [self addComponent:_skin];
        [[AHGraphicsManager manager] addObject:_skin toLayerIndex:GFK_LAYER_BUILDINGS];
    }
    return self;
}


#pragma mark -
#pragma mark update


- (void)updateBeforeAnimation {
    if (GLKVector2Length([_body linearVelocity]) > 3.0f) {
        _hasBeenUpset = YES;
    }
    [_skin setRotation:[_body rotation]];
    [_skin setPosition:[_body position]];
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
