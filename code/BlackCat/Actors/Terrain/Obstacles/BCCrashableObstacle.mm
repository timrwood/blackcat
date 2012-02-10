//
//  BCBlockableObstacle.m
//  BlackCat
//
//  Created by Tim Wood on 2/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define OBSTACLE_HALF_WIDTH  0.1f
#define OBSTACLE_HALF_HEIGHT 2.0f


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
        
        for (int i = 0; i < 4; i ++) {
            BCBreakableRect *rect = [[BCBreakableRect alloc] initWithCenter:position 
                                                                    andSize:size 
                                                                 andTexRect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f) 
                                                                  andTexKey:@"debug-grid.png"];
            [rect setBreakMessageType:MSG_EXPLOSION_RIGHT];
            position = GLKVector2Add(GLKVector2Make(OBSTACLE_HALF_WIDTH * 2.0f, 0.0f), position);
            
            [[AHActorManager manager] add:rect];
        }
    }
    return self;
}


@end
