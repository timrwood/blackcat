//
//  BCBuildingMultiLevel.mm
//  BlackCat
//
//  Created by Tim Wood on 2/14/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define FLOOR_HEIGHT_INCLUDING_CEILING 4.0f
#define CEILING_HEIGHT 0.5f
#define CEILING_EDGE_HEIGHT 0.05f
#define UPPER_HEIGHT 4.0f
#define LOWER_HEIGHT 4.0f

#define BUILDING_WIDTH 32.0f


#import "AHActorManager.h"
#import "AHGraphicsCube.h"
#import "AHPhysicsRect.h"

#import "BCBreakableRect.h"
#import "BCGlobalTypes.h"
#import "BCBuildingMultiLevel.h"


@implementation BCBuildingMultiLevel


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    float centerHeight = self->_startCorner.y;
    [self buildTopAt:centerHeight - FLOOR_HEIGHT_INCLUDING_CEILING * 2.0f];
    [self buildBottomAt:centerHeight + FLOOR_HEIGHT_INCLUDING_CEILING];
    [self buildFloorAt:centerHeight];
    [self buildFloorAt:centerHeight - FLOOR_HEIGHT_INCLUDING_CEILING];
    [self buildBackgroundAt:centerHeight - FLOOR_HEIGHT_INCLUDING_CEILING];
    [self buildBackgroundAt:centerHeight];
    [self buildBackgroundAt:centerHeight + FLOOR_HEIGHT_INCLUDING_CEILING];
    [super setup];
}


#pragma mark -
#pragma mark building


- (void)buildBackgroundAt:(float)height {
    CGSize size = CGSizeMake(BUILDING_WIDTH / 2.0f, FLOOR_HEIGHT_INCLUDING_CEILING / 2.0f);
    GLKVector2 position = GLKVector2Make([self buildingCenterPosition], height - size.height);
    
    CGRect debugRect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    AHGraphicsCube *_skin = [[AHGraphicsCube alloc] init];
    [_skin setRectFromCenter:position andSize:size];
    [_skin setTex:debugRect];
    [_skin setTopTex:debugRect];
    [_skin setBotTex:debugRect];
    [_skin setTextureKey:@"debug-grid.png"];
    [_skin setStartDepth:Z_STAIR_BACK endDepth:Z_BUILDING_BACK];
    [self addComponent:_skin];
}

- (void)buildFloorAt:(float)height {
    CGRect debugRect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    CGRect debugRect2 = CGRectMake(0.0f, 0.0f, 0.2f, 1.0f);
    CGSize size = CGSizeMake(BUILDING_WIDTH / 2.0f, (CEILING_HEIGHT / 2.0f) - CEILING_EDGE_HEIGHT);
    GLKVector2 position = GLKVector2Make([self buildingCenterPosition], height + CEILING_HEIGHT / 2.0f);
    
    CGSize sizeTopBot = size;
    sizeTopBot.height = CEILING_EDGE_HEIGHT / 2.0f;
    
    GLKVector2 positionTop = position;
    GLKVector2 positionBot = position;
    
    positionTop.y -= (CEILING_HEIGHT - CEILING_EDGE_HEIGHT) / 2.0f;
    positionBot.y += (CEILING_HEIGHT - CEILING_EDGE_HEIGHT) / 2.0f;
    
    // center
    BCBreakableRect *rect = [[BCBreakableRect alloc] initWithCenter:position 
                                                            andSize:size 
                                                         andTexRect:debugRect 
                                                          andTexKey:@"debug-grid.png"];
    [rect enableBreakOnDown:YES];
    [rect enableBreakOnUp:YES];
    [rect setStartDepth:Z_BUILDING_FRONT endDepth:Z_STAIR_BACK];
    [[AHActorManager manager] add:rect];
    
    // top
    rect = [[BCBreakableRect alloc] initWithCenter:positionTop 
                                           andSize:sizeTopBot 
                                        andTexRect:debugRect2 
                                         andTexKey:@"debug-grid.png"];
    [rect enableBreakOnRight:YES];
    [rect enableBreakOnDown:YES];
    [rect enableBreakOnUp:YES];
    [rect addTag:PHY_TAG_JUMPABLE];
    [rect setStartDepth:Z_BUILDING_FRONT endDepth:Z_STAIR_BACK];
    [[AHActorManager manager] add:rect];
    
    // bottom
    rect = [[BCBreakableRect alloc] initWithCenter:positionBot 
                                           andSize:sizeTopBot 
                                        andTexRect:debugRect2 
                                         andTexKey:@"debug-grid.png"];
    [rect enableBreakOnRight:YES];
    [rect enableBreakOnDown:YES];
    [rect enableBreakOnUp:YES];
    [rect setStartDepth:Z_BUILDING_FRONT endDepth:Z_STAIR_BACK];
    [[AHActorManager manager] add:rect];
}

- (void)buildBottomAt:(float)height {
    CGSize size = CGSizeMake(BUILDING_WIDTH / 2.0f, LOWER_HEIGHT / 2.0f);
    GLKVector2 position = GLKVector2Make([self buildingCenterPosition], height + size.height);
    
    AHPhysicsRect *_body = [[AHPhysicsRect alloc] initFromSize:size andPosition:position];
    [self configSolidBuilding:_body];
    [self addComponent:_body];
    
    CGRect debugRect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    AHGraphicsCube *_skin = [[AHGraphicsCube alloc] init];
    [_skin setRectFromCenter:position andSize:size];
    [_skin setTex:debugRect];
    [_skin setTopTex:debugRect];
    [_skin setBotTex:debugRect];
    [_skin setTextureKey:@"debug-grid.png"];
    [_skin setStartDepth:Z_BUILDING_FRONT endDepth:Z_BUILDING_BACK];
    [self addComponent:_skin];
}

- (void)buildTopAt:(float)height {
    CGSize size = CGSizeMake(BUILDING_WIDTH / 2.0f, LOWER_HEIGHT / 2.0f);
    GLKVector2 position = GLKVector2Make([self buildingCenterPosition], height - size.height);
    
    AHPhysicsRect *_body = [[AHPhysicsRect alloc] initFromSize:size andPosition:position];
    [self configSolidBuilding:_body];
    [self addComponent:_body];
    
    CGRect debugRect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    AHGraphicsCube *_skin = [[AHGraphicsCube alloc] init];
    [_skin setRectFromCenter:position andSize:size];
    [_skin setTex:debugRect];
    [_skin setTopTex:debugRect];
    [_skin setBotTex:debugRect];
    [_skin setTextureKey:@"debug-grid.png"];
    [_skin setStartDepth:Z_BUILDING_FRONT endDepth:Z_BUILDING_BACK];
    [self addComponent:_skin];
}

- (void)buildWallAtBottomCenter:(GLKVector2)center {
    
}

- (float)buildingCenterPosition {
    return self->_startCorner.x + BUILDING_WIDTH / 2.0f;
}

- (void)configSolidBuilding:(AHPhysicsBody *)body {
    [body setRestitution:0.0f];
    [body setStatic:YES];
    [body setCategory:PHY_CAT_BUILDING];
    [body addTag:PHY_TAG_JUMPABLE];
    [body addTag:PHY_TAG_CRASHABLE];
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
