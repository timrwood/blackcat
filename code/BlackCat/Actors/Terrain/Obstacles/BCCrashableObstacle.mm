//
//  BCBlockableObstacle.m
//  BlackCat
//
//  Created by Tim Wood on 2/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define OBSTACLE_HALF_WIDTH  2.0f
#define OBSTACLE_HALF_HEIGHT 0.25f


#import "BCBreakableRect.h"
#import "AHActorManager.h"
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
        
        [[AHActorManager manager] add:[[BCBreakableRect alloc] initWithCenter:position 
                                                                      andSize:size 
                                                                   andTexRect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f) 
                                                                    andTexKey:@"debug-grid.png"]];
    }
    return self;
}


@end
