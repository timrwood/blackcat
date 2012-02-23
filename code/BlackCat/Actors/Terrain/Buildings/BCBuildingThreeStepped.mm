//
//  BCBuildingStepped010.mm
//  BlackCat
//
//  Created by Tim Wood on 2/2/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define BUILDING_HEIGHT 4.0f
#define STEP_HEIGHT 1.0f
#define STEP_0_WIDTH 16.0f
#define STEP_1_WIDTH 16.0f
#define STEP_2_WIDTH 16.0f

#define SMOOTH_WIDTH 4.0f


#import "AHMathUtils.h"
#import "AHGraphicsCube.h"
#import "AHPhysicsRect.h"

#import "BCGlobalTypes.h"
#import "BCBuildingThreeStepped.h"


@implementation BCBuildingThreeStepped


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _step1 = [[AHPhysicsRect alloc] init];
        [_step1 setStatic:YES];
        [_step1 setRestitution:0.0f];
        [_step1 setCategory:PHY_CAT_BUILDING];
        [_step1 addTag:PHY_TAG_JUMPABLE];
        [_step1 addTag:PHY_TAG_CRASHABLE];
        
        _step2 = [[AHPhysicsRect alloc] init];
        [_step2 setStatic:YES];
        [_step2 setRestitution:0.0f];
        [_step2 setCategory:PHY_CAT_BUILDING];
        [_step2 addTag:PHY_TAG_JUMPABLE];
        [_step2 addTag:PHY_TAG_CRASHABLE];
        
        _step3 = [[AHPhysicsRect alloc] init];
        [_step3 setStatic:YES];
        [_step3 setRestitution:0.0f];
        [_step3 setCategory:PHY_CAT_BUILDING];
        [_step3 addTag:PHY_TAG_JUMPABLE];
        [_step3 addTag:PHY_TAG_CRASHABLE];
        
        [self addComponent:_step1];
        [self addComponent:_step2];
        [self addComponent:_step3];
        
        _skin1 = [[AHGraphicsCube alloc] init];
        _skin2 = [[AHGraphicsCube alloc] init];
        _skin3 = [[AHGraphicsCube alloc] init];
        
        [self addComponent:_skin1];
        [self addComponent:_skin2];
        [self addComponent:_skin3];
        
        [_skin1 setTextureKey:@"buildings.jpg"];
        [_skin2 setTextureKey:@"buildings.jpg"];
        [_skin3 setTextureKey:@"buildings.jpg"];
        //[_skin1 setNormalTextureKey:@"buildings-normal.jpg"];
        //[_skin2 setNormalTextureKey:@"buildings-normal.jpg"];
        //[_skin3 setNormalTextureKey:@"buildings-normal.jpg"];
        
        [_skin1 setTex:CGRectMake(0.0f, 0.25f, 1.0f, 0.25f)];
        [_skin2 setTex:CGRectMake(0.0f, 0.25f, 1.0f, 0.25f)];
        [_skin3 setTex:CGRectMake(0.0f, 0.25f, 1.0f, 0.25f)];
        
        [_skin1 setTopTex:CGRectMake(0.0f, 0.5f, 1.0f, 0.125f)];
        [_skin2 setTopTex:CGRectMake(0.0f, 0.5f, 1.0f, 0.125f)];
        [_skin3 setTopTex:CGRectMake(0.0f, 0.5f, 1.0f, 0.125f)];
        
        [_skin1 setStartDepth:Z_BUILDING_FRONT endDepth:Z_BUILDING_BACK];
        [_skin2 setStartDepth:Z_BUILDING_FRONT endDepth:Z_BUILDING_BACK];
        [_skin3 setStartDepth:Z_BUILDING_FRONT endDepth:Z_BUILDING_BACK];
    }
    return self;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    CGSize step1Size = CGSizeMake(STEP_0_WIDTH / 2.0f, BUILDING_HEIGHT / 2.0f);
    CGSize step2Size = CGSizeMake(STEP_1_WIDTH / 2.0f, BUILDING_HEIGHT / 2.0f);
    CGSize step3Size = CGSizeMake(STEP_2_WIDTH / 2.0f, BUILDING_HEIGHT / 2.0f);
    
    GLKVector2 step1Center;
    GLKVector2 step2Center;
    GLKVector2 step3Center;
    
    step1Center.x = self->_startCorner.x + (STEP_0_WIDTH / 2.0f);
    step2Center.x = self->_startCorner.x + STEP_0_WIDTH + (STEP_1_WIDTH / 2.0f);
    step3Center.x = self->_startCorner.x + STEP_0_WIDTH + STEP_1_WIDTH + (STEP_2_WIDTH / 2.0f);
    
    step1Center.y = self->_startCorner.y + (BUILDING_HEIGHT / 2.0f);
    step2Center.y = step1Center.y + (_step1to2isUp ? -STEP_HEIGHT : STEP_HEIGHT);
    step3Center.y = step2Center.y + (_step2to3isUp ? -STEP_HEIGHT : STEP_HEIGHT);
    
    [_skin1 setRectFromCenter:step1Center andSize:step1Size];
    [_skin2 setRectFromCenter:step2Center andSize:step2Size];
    [_skin3 setRectFromCenter:step3Center andSize:step3Size];
    
    [_step1 setSize:step1Size andPosition:step1Center];
    [_step2 setSize:step2Size andPosition:step2Center];
    [_step3 setSize:step3Size andPosition:step3Center];
    
    [super setup];
}


#pragma mark -
#pragma mark steps


- (void)setStep1to2Up:(BOOL)isUp {
    _step1to2isUp = isUp;
}

- (void)setStep2to3Up:(BOOL)isUp {
    _step2to3isUp = isUp;
}


#pragma mark -
#pragma mark heights


- (GLKVector2)endCorner {
    GLKVector2 end;
    end.x = self->_startCorner.x + STEP_0_WIDTH + STEP_1_WIDTH + STEP_2_WIDTH;
    end.y = self->_startCorner.y;
    end.y += _step1to2isUp ? -STEP_HEIGHT : STEP_HEIGHT;
    end.y += _step2to3isUp ? -STEP_HEIGHT : STEP_HEIGHT;
    return end;
}

- (float)heightAtXPosition:(float)xPos {
    float step1to2 = _startCorner.x + STEP_0_WIDTH;
    float step2to3 = _startCorner.x + STEP_0_WIDTH + STEP_1_WIDTH;
    
    float step1height = self->_startCorner.y;
    float step2height = step1height + (_step1to2isUp ? -STEP_HEIGHT : STEP_HEIGHT);
    float step3height = step2height + (_step2to3isUp ? -STEP_HEIGHT : STEP_HEIGHT);

    if (xPos > step2to3 - (SMOOTH_WIDTH * 0.5f)) {
        return step3height;
    } else if (xPos > step1to2 - (SMOOTH_WIDTH * 0.5f)) {
        return step2height;
    } else {
        return step1height;
    }
}


@end
