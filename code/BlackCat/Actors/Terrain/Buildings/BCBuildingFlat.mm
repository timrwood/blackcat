//
//  BCBuildingActor.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define BUILDING_WIDTH 16.0f
#define BUILDING_HEIGHT 4.0f


#import "AHActorManager.h"
#import "AHGraphicsManager.h"
#import "AHPhysicsRect.h"
#import "AHMathUtils.h"

#import "BCGlobalTypes.h"
#import "BCCrashableObstacle.h"
#import "BCBuildingFlat.h"


@implementation BCBuildingFlat


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _body = [[AHPhysicsRect alloc] init];
        [_body setRestitution:0.0f];
        [_body setStatic:YES];
        [_body setCategory:PHY_CAT_BUILDING];
        [_body addTag:PHY_TAG_JUMPABLE];
        [_body addTag:PHY_TAG_CRASHABLE];
        
        [self addComponent:_body];
        
        _skin = [[AHGraphicsCube alloc] init];
        [_skin setTextureKey:@"debug-grid.png"];
        [_skin setNormalTextureKey:@"debug-normal.jpg"];
        [_skin setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skin setTopTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        [_skin setBotTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        [_skin setStartDepth:Z_BUILDING_FRONT endDepth:Z_BUILDING_BACK];
        [self addComponent:_skin];
        
        rotation = 0.0f;
    }
    return self;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    CGSize size = CGSizeMake(BUILDING_WIDTH / 2.0f, BUILDING_HEIGHT / 2.0f);
    
    GLKVector2 center;
    center.x = self->_startCorner.x + (BUILDING_WIDTH / 2.0f);
    center.y = self->_startCorner.y + (BUILDING_HEIGHT / 2.0f);
    
    [_skin setRectFromCenter:center andSize:size];
    [_body setSize:size andPosition:center];
    
    // add an obstacle
    //GLKVector2 obsPos = GLKVector2Make(center.x - 4.0f, self->_startCorner.y);
    //BCCrashableObstacle *obstacle = [[BCCrashableObstacle alloc] initAtBottomCenterPoint:obsPos];
    //[[AHActorManager manager] add:obstacle];

    center.x = self->_startCorner.x + 4.0f;
    center.y = self->_startCorner.y - 1.0f;
    
    cube = [[AHGraphicsCube alloc] init];
    [cube setRectFromCenter:GLKVector2Zero() andRadius:0.5f];
    
    [cube setPosition:center];
    [cube setOffsetHorizontal:YES];
    [cube setRightYTopOffset:-0.5f andRightYBottomOffset:0.5f];
    [cube setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
    [cube setTextureKey:@"debug-grid.png"];
    [cube setStartDepth:Z_BUILDING_FRONT endDepth:Z_BUILDING_BACK];
    //[self addComponent:cube];
    
    [super setup];
}


#pragma mark -
#pragma mark heights


- (GLKVector2)endCorner {
    GLKVector2 end;
    end.x = self->_startCorner.x + BUILDING_WIDTH;
    end.y = self->_startCorner.y;
    return end;
}


#pragma mark -
#pragma mark update


- (void)updateBeforeRender {
    rotation += 0.01f;
    [cube setRotation:rotation];
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupBeforeDestruction {
    _body = nil;
    _skin = nil;
    
    [super cleanupBeforeDestruction];
}

@end
