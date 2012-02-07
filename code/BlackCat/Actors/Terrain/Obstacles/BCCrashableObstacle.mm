//
//  BCBlockableObstacle.m
//  BlackCat
//
//  Created by Tim Wood on 2/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define OBSTACLE_HALF_WIDTH  1.0f
#define OBSTACLE_HALF_HEIGHT 0.7f


#import "AHPhysicsRect.h"

#import "BCGlobalTypes.h"
#import "BCCrashableObstacle.h"


@implementation BCCrashableObstacle


#pragma mark -
#pragma mark init


- (id)initAtBottomCenterPoint:(GLKVector2)bottomCenter {
    self = [super init];
    if (self) {
        CGSize size = CGSizeMake(OBSTACLE_HALF_WIDTH, OBSTACLE_HALF_HEIGHT);
        GLKVector2 position = GLKVector2Make(bottomCenter.x, bottomCenter.y - OBSTACLE_HALF_HEIGHT);
        
        _body = [[AHPhysicsRect alloc] initFromSize:size andPosition:position];
        [_body addTag:PHY_TAG_CRASHABLE];
        [_body addTag:PHY_TAG_BREAKABLE];
        [_body addTag:PHY_TAG_PHASEWALKABLE];
        [_body setCategory:PHY_CAT_CRASHABLE];
        [_body setStatic:YES];
        [self addComponent:_body];
        
        _skin = [[AHGraphicsRect alloc] init];
        [_skin setRectFromCenter:position andSize:size];
        [_skin setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skin setTextureKey:@"debug-grid.png"];
        [self addComponent:_skin];
    }
    return self;
}


@end
