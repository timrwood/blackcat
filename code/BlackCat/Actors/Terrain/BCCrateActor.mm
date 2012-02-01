//
//  BCCrateActor.mm
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define CRATE_SIZE 0.1f


#import "AHMathUtils.h"
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
        CGSize size = CGSizeMake([BCCrateActor width], [BCCrateActor height]);
        
        _body = [[AHPhysicsRect alloc] initFromSize:size andPosition:position];
        [_body setStatic:NO];
        [_body addTag:PHY_TAG_DEBRIS];
        [_body setDelegate:self];
        [self addComponent:_body];
        
        size.width *= 1.1f;
        size.height *= 1.1f;
        
        _skin = [[AHGraphicsRect alloc] init];
        [_skin setRectFromCenter:GLKVector2Make(0.0f, 0.0f) andSize:size];
        [_skin setTextureKey:@"misc-objects.png"];
        float x = 0.0f;
        float y = 0.0f;
        if (rand() % 2 == 0) {
            x = TX_1_16;
        }
        if (rand() % 2 == 0) {
            y = TX_1_16;
        }
        [_skin setTex:CGRectMake(x, y, TX_1_16, TX_1_16)];
        [_skin setLayerIndex:GFK_LAYER_BUILDINGS];
        [self addComponent:_skin];
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
            GLKVector2 force = [contact linearVelocity];
            force.x *= 1.2f;
            force.y *= 1.2f;
            [_body setLinearVelocity:force atWorldPoint:[contact position]];
            _hasBeenUpset = YES;
        }
        return NO;
    }
    return YES;
}


#pragma mark -
#pragma mark static vars


+ (float)width {
    return CRATE_SIZE;
}

+ (float)height {
    return CRATE_SIZE * 0.8f;
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupBeforeDestruction {
    _skin = nil;
    _body = nil;
    [super cleanupBeforeDestruction];
}


@end
