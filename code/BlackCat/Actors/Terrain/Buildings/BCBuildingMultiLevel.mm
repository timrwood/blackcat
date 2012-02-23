//
//  BCBuildingMultiLevel.mm
//  BlackCat
//
//  Created by Tim Wood on 2/14/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define FLOOR_HEIGHT_INCLUDING_CEILING 3.0f
#define CEILING_HEIGHT 0.33f
#define CEILING_EDGE_HEIGHT 0.05f
#define UPPER_HEIGHT 4.0f
#define LOWER_HEIGHT 4.0f

#define WALL_WIDTH 8.0f

#define BUILDING_WIDTH 56.0f


#import "AHActorManager.h"
#import "AHGraphicsCube.h"
#import "AHPhysicsRect.h"

#import "BCBreakableRect.h"
#import "BCGlobalManager.h"
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
    
    for (int i = 0; i < 4; i++) {
        float layer = (float)((rand() % 3 - 1)) * FLOOR_HEIGHT_INCLUDING_CEILING;
        float offset = (BUILDING_WIDTH / 5.0f) * (float) (i + 1);
        GLKVector2 pos = GLKVector2Add(self->_startCorner, GLKVector2Make(offset, layer));
        [self buildWallAtBottomCenter:pos];
    }
    
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
    //CGRect debugRect2 = CGRectMake(0.0f, 0.0f, 0.2f, 1.0f);
    CGSize size = CGSizeMake(BUILDING_WIDTH / 2.0f, CEILING_HEIGHT / 2.0f);
    GLKVector2 position = GLKVector2Make([self buildingCenterPosition], height + size.height);
    
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
    [rect addTag:PHY_TAG_JUMPABLE];
    [rect setCategory:PHY_CAT_BUILDING];
    [rect setRestitution:0.0f];
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
    if (NO) {
        [self buildWallAtBottomCenterBreakable:center];
        return;
    }
    
    CGSize size = CGSizeMake(WALL_WIDTH / 2.0f, (FLOOR_HEIGHT_INCLUDING_CEILING - CEILING_HEIGHT) / 2.0f);
    GLKVector2 position = GLKVector2Make(0.0f, -size.height);
    
    AHPhysicsRect *_body = [[AHPhysicsRect alloc] initFromSize:size];
    [_body setRestitution:0.0f];
    [_body setStatic:YES];
    [_body setCategory:PHY_CAT_BUILDING];
    [_body setPosition:GLKVector2Add(position, center)];
    [self addComponent:_body];
    
    AHGraphicsCube *_skin = [[AHGraphicsCube alloc] init];
    [_skin setRectFromCenter:position andSize:size];
    [_skin setPosition:center];
    [_skin setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
    [_skin setTextureKey:@"debug-grid.png"];
    [_skin setStartDepth:Z_BUILDING_FRONT endDepth:Z_STAIR_BACK];
    [self addComponent:_skin];
}

- (void)buildWallAtBottomCenterBreakable:(GLKVector2)center {
    CGSize size = CGSizeMake(WALL_WIDTH / 16.0f, (FLOOR_HEIGHT_INCLUDING_CEILING - CEILING_HEIGHT) / 2.0f);
    GLKVector2 position = GLKVector2Make(-size.width * 8.0f, -size.height);
    
    for (int i = 0; i < 8; i++) {
        BCBreakableRect *rect = [[BCBreakableRect alloc] initWithCenter:GLKVector2Add(position, center) 
                                                                andSize:size                                                             andTexRect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f) 
                                                              andTexKey:@"debug-grid.png"];
        [rect enableBreakOnRight:YES];
        [rect setStartDepth:Z_BUILDING_FRONT endDepth:Z_STAIR_BACK];
        position.x += size.width * 2.0f;
        [[AHActorManager manager] add:rect];
    }
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

- (float)heightAtXPosition:(float)xPos {
    float heightStart = self->_startCorner.y;
    return heightStart;
    
    GLKVector2 heroPosition = [[BCGlobalManager manager] heroPosition];
    
    if (heroPosition.y < heightStart - FLOOR_HEIGHT_INCLUDING_CEILING) {
        return heightStart - FLOOR_HEIGHT_INCLUDING_CEILING;
    } else if (heroPosition.y > heightStart) {
        return heightStart + FLOOR_HEIGHT_INCLUDING_CEILING;
    }    
    
    return heightStart;
}


@end
