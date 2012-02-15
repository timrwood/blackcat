//
//  BCBuildingSplitter.mm
//  BlackCat
//
//  Created by Tim Wood on 2/7/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define BUILDING_HEIGHT 6.0f

#define STEP_0_WIDTH 10.0f
#define STEP_1_WIDTH 8.0f

#define STAIR_CEILING_OFFSET_LEFT 2.0f
#define STAIR_CEILING_OFFSET_RIGHT 0.5f
#define STAIR_CEILING_HEIGHT 2.0f
#define STAIR_CEILING_DEPTH 0.2f

#define STAIR_WIDTH 3.0f
#define STAIR_HEIGHT 3.0f



#import "AHMathUtils.h"
#import "AHPhysicsPolygon.h"
#import "AHPhysicsRect.h"

#import "BCGlobalTypes.h"
#import "BCBuildingSplitter.h"


@implementation BCBuildingSplitter


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _step1 = [[AHPhysicsPolygon alloc] init];
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
        
        _stairCeiling = [[AHPhysicsPolygon alloc] init];
        [_stairCeiling setStatic:YES];
        [_stairCeiling setRestitution:0.0f];
        [_stairCeiling setCategory:PHY_CAT_BUILDING];
        [_stairCeiling addTag:PHY_TAG_JUMPABLE];
        
        _stairCeilingEnd = [[AHPhysicsRect alloc] init];
        [_stairCeilingEnd setStatic:YES];
        [_stairCeilingEnd setRestitution:0.0f];
        [_stairCeilingEnd setCategory:PHY_CAT_BUILDING];
        [_stairCeilingEnd addTag:PHY_TAG_JUMPABLE];
        [_stairCeilingEnd addTag:PHY_TAG_ONE_WAY_FLOOR];
        
        [self addComponent:_step1];
        [self addComponent:_step2];
        [self addComponent:_stairCeiling];
        [self addComponent:_stairCeilingEnd];
        
        _skin1 = [[AHGraphicsCube alloc] init];
        _skin2 = [[AHGraphicsCube alloc] init];
        _skinCeiling1 = [[AHGraphicsCube alloc] init];
        _skinCeiling2 = [[AHGraphicsCube alloc] init];
        _skinCeiling3 = [[AHGraphicsCube alloc] init];
        _skinBack = [[AHGraphicsCube alloc] init];
        _skinStair = [[AHGraphicsCube alloc] init];
        
        [self addComponent:_skin1];
        [self addComponent:_skin2];
        [self addComponent:_skinCeiling1];
        [self addComponent:_skinCeiling2];
        [self addComponent:_skinCeiling3];
        [self addComponent:_skinBack];
        [self addComponent:_skinStair];
        
        [_skin1 setTextureKey:@"debug-grid.png"];
        [_skin2 setTextureKey:@"debug-grid.png"];
        [_skinCeiling1 setTextureKey:@"debug-grid.png"];
        [_skinCeiling2 setTextureKey:@"debug-grid.png"];
        [_skinCeiling3 setTextureKey:@"debug-grid.png"];
        [_skinBack setTextureKey:@"debug-grid.png"];
        [_skinStair setTextureKey:@"debug-grid.png"];
        
        [_skin1 setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skin2 setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skinCeiling1 setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skinCeiling2 setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skinCeiling3 setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skinBack setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        
        [_skin1 setTopTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        [_skin2 setTopTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        [_skinCeiling1 setTopTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        [_skinCeiling2 setTopTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        [_skinCeiling3 setTopTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        [_skinBack setTopTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        [_skinStair setTopTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        
        [_skin1 setBotTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        [_skin2 setBotTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        [_skinCeiling1 setBotTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        [_skinCeiling2 setBotTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        [_skinCeiling3 setBotTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        [_skinBack setBotTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        [_skinStair setBotTex:CGRectMake(0.0f, 0.0f, 2.0f, 1.0f)];
        
        [_skin1 setStartDepth:Z_BUILDING_FRONT endDepth:Z_STAIR_BACK];
        [_skin2 setStartDepth:Z_BUILDING_FRONT endDepth:Z_STAIR_BACK];
        [_skinCeiling1 setStartDepth:Z_BUILDING_FRONT endDepth:Z_STAIR_BACK];
        [_skinCeiling2 setStartDepth:Z_BUILDING_FRONT endDepth:Z_STAIR_BACK];
        [_skinCeiling3 setStartDepth:Z_BUILDING_FRONT endDepth:Z_STAIR_BACK];
        [_skinBack setStartDepth:Z_STAIR_BACK endDepth:Z_BUILDING_BACK];
        [_skinStair setStartDepth:Z_BUILDING_FRONT endDepth:Z_STAIR_BACK];
    }
    return self;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    [self setupStep1];
    [self setupStep2];
    [self setupStairCeiling];
    [self setupStairCeilingMiddle];
    [self setupStairCeilingEnd];
    [self setupStepBack];
    [self setupStairSteps];
    [super setup];
}

- (void)setupStep1 {
    CGSize size = CGSizeMake((STEP_0_WIDTH) / 2.0f, BUILDING_HEIGHT / 2.0f); 
    GLKVector2 center;
    center.x = self->_startCorner.x + size.width;
    center.y = self->_startCorner.y + (BUILDING_HEIGHT / 2.0f);
    
    float right      = (STEP_0_WIDTH / 2.0f) + STAIR_WIDTH;
    float left       = - (STEP_0_WIDTH / 2.0f);
    float bot        = BUILDING_HEIGHT / 2.0f;
    float top        = - bot;
    float topStair   = top + STAIR_HEIGHT;
    float rightStair = right - STAIR_WIDTH;
    
    GLKVector2 points[5];
    points[0] = GLKVector2Make(left,       top);      // top left
    points[1] = GLKVector2Make(rightStair, top);      // stair top
    points[2] = GLKVector2Make(right,      topStair); // stair bot
    points[3] = GLKVector2Make(right,      bot);      // bot right
    points[4] = GLKVector2Make(left,       bot);      // bot left
    
    [_step1 setPoints:points andCount:5];
    [_step1 setPosition:center];
    [_skin1 setRectFromCenter:center andSize:size];
}

- (void)setupStep2 {
    CGSize size = CGSizeMake(STEP_1_WIDTH / 2.0f, BUILDING_HEIGHT / 2.0f);
    GLKVector2 center;
    center.x = self->_startCorner.x + STEP_0_WIDTH + STAIR_WIDTH + (STEP_1_WIDTH / 2.0f);
    center.y = self->_startCorner.y + STAIR_HEIGHT + (BUILDING_HEIGHT / 2.0f);
    
    [_step2 setSize:size andPosition:center];
    [_skin2 setRectFromCenter:center andSize:size];
}

- (void)setupStairCeiling {
    GLKVector2 center;
    center.x = self->_startCorner.x + STEP_0_WIDTH;
    center.y = self->_startCorner.y;
    
    float bot = 0.0f;
    float top = bot - STAIR_CEILING_HEIGHT;
    float x1 = -STAIR_CEILING_OFFSET_LEFT;
    float x2 = x1 + STAIR_CEILING_OFFSET_LEFT + STAIR_CEILING_OFFSET_RIGHT;
    float x3 = x2 + STAIR_CEILING_HEIGHT;
    
    GLKVector2 points[6];
    points[0] = GLKVector2Make(x1, top);
    points[1] = GLKVector2Make(x2, top);
    points[2] = GLKVector2Make(x3, bot);
    points[3] = GLKVector2Make(x3, bot + STAIR_CEILING_DEPTH);
    points[4] = GLKVector2Make(x2, top + STAIR_CEILING_DEPTH);
    points[5] = GLKVector2Make(x1, top + STAIR_CEILING_DEPTH);
    
    [_stairCeiling setPoints:points andCount:6];
    [_stairCeiling setPosition:center];
    [_stairCeiling setEdge:YES];
    
    CGSize topSize = CGSizeMake((x2 - x1) / 2.0f, STAIR_CEILING_DEPTH / 2.0f);
    
    GLKVector2 topPos = GLKVector2Make(x1 + topSize.width, top + topSize.height);
    
    [_skinCeiling1 setRectFromCenter:GLKVector2Add(topPos, center) andSize:topSize];
}

- (void)setupStairCeilingMiddle {
    float cos45 = cosf(M_TAU_8);
    float width = sqrtf(STAIR_CEILING_HEIGHT * STAIR_CEILING_HEIGHT + STAIR_CEILING_HEIGHT * STAIR_CEILING_HEIGHT);
    float height = STAIR_CEILING_DEPTH * cos45 / 2.0f;
    CGSize size = CGSizeMake(height, width / 2.0f);
    GLKVector2 center;
    center.x = self->_startCorner.x + STEP_0_WIDTH + STAIR_CEILING_OFFSET_RIGHT + STAIR_CEILING_HEIGHT / 2.0f - STAIR_CEILING_DEPTH / 4.0f;
    center.y = self->_startCorner.y - (STAIR_CEILING_HEIGHT - STAIR_CEILING_DEPTH / 2.0f) / 2.0f;
    
    [_skinCeiling3 setRectFromCenter:GLKVector2Zero() andSize:size];
    [_skinCeiling3 setPosition:center];
    [_skinCeiling3 setRotation:M_TAU_8 + M_TAU_4];
    [_skinCeiling3 setRightYTopOffset:-height * 2.0f andRightYBottomOffset:-height * 2.0f];
}

- (void)setupStairCeilingEnd {
    float width = ((STAIR_WIDTH + STEP_1_WIDTH) - (STAIR_CEILING_OFFSET_RIGHT + STAIR_CEILING_HEIGHT)) / 2.0f;
    CGSize size = CGSizeMake(width, STAIR_CEILING_DEPTH / 2.0f);
    GLKVector2 center;
    center.x = [self endCorner].x - width;
    center.y = self->_startCorner.y + size.height;
    
    [_stairCeilingEnd setSize:size andPosition:center];
    [_skinCeiling2 setRectFromCenter:center andSize:size];
}

- (void)setupStepBack {
    CGSize size = CGSizeMake((STEP_0_WIDTH + STAIR_WIDTH + STEP_1_WIDTH) / 2.0f, BUILDING_HEIGHT / 2.0f); 
    GLKVector2 center;
    center.x = self->_startCorner.x + size.width;
    center.y = self->_startCorner.y + (BUILDING_HEIGHT / 2.0f);
    [_skinBack setRectFromCenter:center andSize:size];
}

- (void)setupStairSteps {
    CGSize size = CGSizeMake(STAIR_WIDTH / 2.0f, BUILDING_HEIGHT / 2.0f); 
    GLKVector2 center;
    center.x = self->_startCorner.x + STEP_0_WIDTH + size.width;
    center.y = self->_startCorner.y + (BUILDING_HEIGHT / 2.0f);
    [_skinStair setRightYTopOffset:size.height andRightYBottomOffset:0.0f];
    [_skinStair setRectFromCenter:center andSize:size];
    [_skinStair setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
}


#pragma mark -
#pragma mark heights


- (GLKVector2)endCorner {
    GLKVector2 end;
    end.x = self->_startCorner.x + STEP_0_WIDTH + STEP_1_WIDTH + STAIR_WIDTH;
    end.y = self->_startCorner.y + STAIR_HEIGHT;
    return end;
}

- (float)heightAtXPosition:(float)xPos {
    float stairStart = self->_startCorner.x + STEP_0_WIDTH;
    float stairEnd = self->_startCorner.x + STEP_0_WIDTH + STAIR_WIDTH;
    float heightStart = self->_startCorner.y;
    float heightEnd = self->_startCorner.y + (STAIR_HEIGHT / 2.0f);
    
    if (xPos > stairEnd) {
        return heightEnd;
    } else if (xPos > stairStart) {
        float percent = FloatPercentBetween(stairStart, stairEnd, xPos);
        return FloatLerp(heightStart, heightEnd, percent);
    }
    
    return heightStart;
}


@end
