//
//  BCBuildingActor.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define BUILDING_WIDTH 16.0f
#define BUILDING_HEIGHT 4.0f


#import "AHGraphicsManager.h"
#import "AHGraphicsRect.h"
#import "AHPhysicsRect.h"
#import "AHMathUtils.h"

#import "BCGlobalTypes.h"
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
        
        _skin = [[AHGraphicsRect alloc] init];
        [_skin setTextureKey:@"debug-grid.png"];
        [_skin setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [self addComponent:_skin];
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
