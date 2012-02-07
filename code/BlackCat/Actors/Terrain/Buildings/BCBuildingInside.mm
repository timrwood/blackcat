//
//  BCBuildingActor.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define BUILDING_WIDTH 16.0f
#define BUILDING_HEIGHT 4.0f

#define CORNER_HEIGHT_PERCENT 0.4f
#define CORNER_WIDTH_PERCENT 0.2f

#define OPENING_HEIGHT 2.0f


#import "AHGraphicsManager.h"
#import "AHGraphicsRect.h"
#import "AHPhysicsPolygon.h"
#import "AHPhysicsRect.h"
#import "AHMathUtils.h"

#import "BCGlobalTypes.h"
#import "BCBuildingInside.h"


@implementation BCBuildingInside


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _bodyTop = [[AHPhysicsPolygon alloc] init];
        [_bodyTop setRestitution:0.0f];
        [_bodyTop setStatic:YES];
        [_bodyTop setCategory:PHY_CAT_BUILDING];
        [_bodyTop addTag:PHY_TAG_JUMPABLE];
        [self addComponent:_bodyTop];
        
        _bodyBot = [[AHPhysicsRect alloc] init];
        [_bodyBot setRestitution:0.0f];
        [_bodyBot setStatic:YES];
        [_bodyBot setCategory:PHY_CAT_BUILDING];
        [_bodyBot addTag:PHY_TAG_CRASHABLE];
        [_bodyBot addTag:PHY_TAG_JUMPABLE];
        [self addComponent:_bodyBot];
        
        _skinTop = [[AHGraphicsRect alloc] init];
        [_skinTop setTextureKey:@"debug-grid.png"];
        [_skinTop setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [self addComponent:_skinTop];
        
        _skinBot = [[AHGraphicsRect alloc] init];
        [_skinBot setTextureKey:@"debug-grid.png"];
        [_skinBot setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [self addComponent:_skinBot];
    }
    return self;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    CGSize size = CGSizeMake(BUILDING_WIDTH / 2.0f, BUILDING_HEIGHT / 2.0f);
    
    GLKVector2 centerTop;
    centerTop.x = self->_startCorner.x + (BUILDING_WIDTH / 2.0f);
    centerTop.y = self->_startCorner.y - (OPENING_HEIGHT + BUILDING_HEIGHT / 2.0f);
    
    GLKVector2 centerBot;
    centerBot.x = self->_startCorner.x + (BUILDING_WIDTH / 2.0f);
    centerBot.y = self->_startCorner.y + (BUILDING_HEIGHT / 2.0f);
    
    [_skinTop setRectFromCenter:centerTop andSize:size];
    
    [_skinBot setRectFromCenter:centerBot andSize:size];
    [_bodyBot setSize:size andPosition:centerBot];
    
    // top corner
    float left = - BUILDING_WIDTH / 2.0f;
    float right = BUILDING_WIDTH / 2.0f;
    float top = - BUILDING_HEIGHT / 2.0f;
    float bot = BUILDING_HEIGHT / 2.0f;
    float leftCorner = left + (BUILDING_WIDTH * CORNER_WIDTH_PERCENT);
    float rightCorner = right - (BUILDING_WIDTH * CORNER_WIDTH_PERCENT);
    float botCorner = bot - (BUILDING_HEIGHT * CORNER_HEIGHT_PERCENT);
    
    GLKVector2 topVector[6];
    topVector[0] = GLKVector2Make(left,        top); // top left
    topVector[1] = GLKVector2Make(right,       top); // top right
    topVector[2] = GLKVector2Make(right,       botCorner); // bottom right
    topVector[3] = GLKVector2Make(rightCorner, bot); // bottom right
    topVector[4] = GLKVector2Make(leftCorner,  bot); // bottom corner
    topVector[5] = GLKVector2Make(left,        botCorner); // left corner
    [_bodyTop setPoints:topVector andCount:6];
    [_bodyTop setPosition:centerTop];
    
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


@end
