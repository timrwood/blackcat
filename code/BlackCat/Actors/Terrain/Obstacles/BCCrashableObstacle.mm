//
//  BCBlockableObstacle.m
//  BlackCat
//
//  Created by Tim Wood on 2/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define OBSTACLE_HALF_WIDTH  0.2f
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
        
        CGSize size2 = CGSizeMake(OBSTACLE_HALF_WIDTH / 4.0f, OBSTACLE_HALF_HEIGHT);
        GLKVector2 position2 = GLKVector2Make(bottomCenter.x - size2.width * 3.0f, bottomCenter.y - OBSTACLE_HALF_HEIGHT);
        
        // front skin
        _frontSkin = [[AHGraphicsCube alloc] init];
        [_frontSkin setRectFromCenter:position andSize:size];
        [_frontSkin setTextureKey:@"debug-grid.png"];
        [_frontSkin setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_frontSkin setTopTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_frontSkin setBotTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_frontSkin setStartDepth:Z_BUILDING_FRONT endDepth:Z_PHYSICS_FRONT];
        //[self addComponent:_frontSkin];
        
        // back skin
        _backSkin = [[AHGraphicsCube alloc] init];
        [_backSkin setRectFromCenter:position andSize:size];
        [_backSkin setTextureKey:@"debug-grid.png"];
        [_backSkin setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_backSkin setTopTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_backSkin setBotTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_backSkin setStartDepth:Z_PHYSICS_BACK endDepth:Z_BUILDING_BACK];
        //[self addComponent:_backSkin];
        
        CGRect trect = CGRectMake(0.25f, 0.0f, -0.25f, 1.0f);
        
        for (int i = 0; i < 4; i ++) {
            BCBreakableRect *rect = [[BCBreakableRect alloc] initWithCenter:position2 
                                                                    andSize:size2 
                                                                 andTexRect:trect 
                                                                  andTexKey:@"debug-grid.png"];
            [rect enableBreakOnRight:YES];
            [rect setStartDepth:Z_PHYSICS_FRONT endDepth:Z_PHYSICS_BACK];
            position2.x += size2.width * 2.0f;
            trect.origin.x += 0.25f;
            
            [[AHActorManager manager] add:rect];
            //[rect breakAtPoint:position2 withRadius:1.0f];
        }
        
        /*
        GLKVector2 vec = position;
        vec.x -= OBSTACLE_HALF_HEIGHT * 2.0f;
        
        CGSize size4 = CGSizeMake(OBSTACLE_HALF_HEIGHT, OBSTACLE_HALF_WIDTH);
        BCBreakableRect *rect = [[BCBreakableRect alloc] initWithCenter:vec 
                                                                andSize:size4 
                                                             andTexRect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f) 
                                                              andTexKey:@"debug-grid.png"];
        [rect setStartDepth:Z_PHYSICS_FRONT endDepth:Z_PHYSICS_BACK];
        
        [[AHActorManager manager] add:rect];
        
        vec.y += 0.05f;
        [rect breakAtPoint:vec withRadius:1.0f];
        
        vec.y -= 0.05f;
        
        vec.y += OBSTACLE_HALF_WIDTH * 10.5f;
        rect = [[BCBreakableRect alloc] initWithCenter:vec 
                                               andSize:size4 
                                            andTexRect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f) 
                                             andTexKey:@"debug-grid.png"];
        [rect setStartDepth:Z_PHYSICS_FRONT endDepth:Z_PHYSICS_BACK];
        
        [[AHActorManager manager] add:rect];
        vec.y += 0.05f;
        [rect breakAtPoint:vec withRadius:1.0f];
         */
         
    }
    return self;
}


@end
