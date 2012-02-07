//
//  BCBuildingActor.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define BUILDING_WIDTH 16.0f
#define BUILDING_HEIGHT 4.0f

#define OPENING_HEIGHT 3.0f


#import "AHGraphicsManager.h"
#import "AHGraphicsRect.h"
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
        _bodyTop = [[AHPhysicsRect alloc] init];
        [_bodyTop setRestitution:0.0f];
        [_bodyTop setStatic:YES];
        [_bodyTop setCategory:PHY_CAT_BUILDING];
        [_bodyTop addTag:PHY_TAG_JUMPABLE];
        [self addComponent:_bodyTop];
        
        _bodyBot = [[AHPhysicsRect alloc] init];
        [_bodyBot setRestitution:0.0f];
        [_bodyBot setStatic:YES];
        [_bodyBot setCategory:PHY_CAT_BUILDING];
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
    [_bodyTop setSize:size andPosition:centerTop];
    
    [_skinBot setRectFromCenter:centerBot andSize:size];
    [_bodyBot setSize:size andPosition:centerBot];
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
