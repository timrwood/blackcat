//
//  BCBuildingSplitter.mm
//  BlackCat
//
//  Created by Tim Wood on 2/7/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define BUILDING_HEIGHT 6.0f

#define STEP_0_WIDTH 12.0f
#define STEP_1_WIDTH 10.0f

#define STAIR_CEILING_OFFSET 3.0f
#define STAIR_CEILING_HEIGHT 2.5f
#define STAIR_CEILING_DEPTH 0.2f

#define STAIR_WIDTH 4.0f
#define STAIR_HEIGHT 2.0f



#import "AHMathUtils.h"
#import "AHPhysicsPolygon.h"
#import "AHPhysicsRect.h"

#import "BCGlobalTypes.h"
#import "BCGlobalManager.h"
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
        
        [self addComponent:_step1];
        [self addComponent:_step2];
        [self addComponent:_stairCeiling];
        
        _skinGroundTop = [[AHGraphicsCube alloc] init];
        [self addComponent:_skinGroundTop];
        [_skinGroundTop setTextureKey:@"debug-grid.png"];
        [_skinGroundTop setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skinGroundTop setStartDepth:Z_BUILDING_FRONT endDepth:Z_BUILDING_BACK];
        
        _skinGroundBot = [[AHGraphicsCube alloc] init];
        [self addComponent:_skinGroundBot];
        [_skinGroundBot setTextureKey:@"debug-grid.png"];
        [_skinGroundBot setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skinGroundBot setStartDepth:Z_BUILDING_FRONT endDepth:Z_BUILDING_BACK];
        
        _skinStairTop = [[AHGraphicsCube alloc] init];
        [self addComponent:_skinStairTop];
        [_skinStairTop setTextureKey:@"debug-grid.png"];
        [_skinStairTop setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skinStairTop setStartDepth:Z_STAIR_FRONT endDepth:Z_STAIR_BACK];
        
        _skinStairAngled = [[AHGraphicsCube alloc] init];
        [self addComponent:_skinStairAngled];
        [_skinStairAngled setTextureKey:@"debug-grid.png"];
        [_skinStairAngled setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skinStairAngled setStartDepth:Z_STAIR_FRONT endDepth:Z_STAIR_BACK];
        
        _skinStairBotCeil = [[AHGraphicsCube alloc] init];
        [self addComponent:_skinStairBotCeil];
        [_skinStairBotCeil setTextureKey:@"debug-grid.png"];
        [_skinStairBotCeil setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skinStairBotCeil setStartDepth:Z_STAIR_FRONT + Z_WALL_WIDTH endDepth:Z_STAIR_BACK - Z_WALL_WIDTH];
        
        _skinStairBotBack = [[AHGraphicsCube alloc] init];
        [self addComponent:_skinStairBotBack];
        [_skinStairBotBack setTextureKey:@"debug-grid.png"];
        [_skinStairBotBack setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skinStairBotBack setStartDepth:Z_STAIR_BACK - Z_WALL_WIDTH endDepth:Z_STAIR_BACK];
        
        _skinStairBotFront = [[AHGraphicsCube alloc] init];
        [self addComponent:_skinStairBotFront];
        [_skinStairBotFront setTextureKey:@"debug-grid.png"];
        [_skinStairBotFront setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skinStairBotFront setStartDepth:Z_STAIR_FRONT endDepth:Z_STAIR_FRONT + Z_WALL_WIDTH];
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
    [_skinGroundTop setRectFromCenter:center andSize:size];
}

- (void)setupStep2 {
    CGSize size = CGSizeMake((STEP_1_WIDTH + STAIR_WIDTH) / 2.0f, BUILDING_HEIGHT / 2.0f);
    GLKVector2 center;
    center.x = self->_startCorner.x + STEP_0_WIDTH + size.width;
    center.y = self->_startCorner.y + STAIR_HEIGHT + (BUILDING_HEIGHT / 2.0f);
    
    [_step2 setSize:size andPosition:center];
    [_skinGroundBot setRectFromCenter:center andSize:size];
}

- (void)setupStairCeiling {
    GLKVector2 center;
    center.x = self->_startCorner.x + STEP_0_WIDTH;
    center.y = self->_startCorner.y;
    
    float bot = 0.0f;
    float top = bot - STAIR_CEILING_HEIGHT;
    float x1 = -STAIR_CEILING_OFFSET;
    float x2 = 0.0f;
    float x3 = x2 + STAIR_WIDTH;
    float x4 = x3 + STAIR_CEILING_OFFSET;
    
    GLKVector2 points[6];
    points[0] = GLKVector2Make(x1, top);
    points[1] = GLKVector2Make(x2, top);
    points[2] = GLKVector2Make(x3, bot);
    points[3] = GLKVector2Make(x4, bot);
    points[4] = GLKVector2Make(x4, bot + STAIR_CEILING_DEPTH);
    points[5] = GLKVector2Make(x3, bot + STAIR_CEILING_DEPTH);
    points[6] = GLKVector2Make(x2, top + STAIR_CEILING_DEPTH);
    points[7] = GLKVector2Make(x1, top + STAIR_CEILING_DEPTH);
    
    [_stairCeiling setPoints:points andCount:8];
    [_stairCeiling setPosition:center];
    [_stairCeiling setEdge:YES];
    
    CGSize topSize = CGSizeMake(STAIR_CEILING_OFFSET / 2.0f, STAIR_CEILING_HEIGHT / 2.0f);
    GLKVector2 topPos = GLKVector2Make(-topSize.width, top + topSize.height);
    
    [_skinStairTop setRectFromCenter:topPos andSize:topSize];
    [_skinStairTop setPosition:center];
}

- (void)setupStairCeilingMiddle {
    CGSize size = CGSizeMake(STAIR_WIDTH / 2.0f, (STAIR_HEIGHT + STAIR_CEILING_HEIGHT) / 2.0f); 
    GLKVector2 center = self->_startCorner;
    center.x += STEP_0_WIDTH + size.width;
    center.y += size.height - STAIR_CEILING_HEIGHT;
    [_skinStairAngled setRightYTopOffset:STAIR_CEILING_HEIGHT andRightYBottomOffset:0.0f];
    [_skinStairAngled setRectFromCenter:center andSize:size];
    [_skinStairAngled setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
}

- (void)setupStairCeilingEnd {
    float width = STAIR_CEILING_OFFSET / 2.0f;
    CGSize wallSize = CGSizeMake(width, STAIR_HEIGHT / 2.0f);
    CGSize ceilSize = CGSizeMake(width, STAIR_CEILING_DEPTH / 2.0f);
    GLKVector2 wallCenter = GLKVector2Add([self endCorner], GLKVector2Make(width - STEP_1_WIDTH, -wallSize.height));
    GLKVector2 ceilCenter = wallCenter;
    ceilCenter.y += ceilSize.height - wallSize.height;
    
    [_skinStairBotCeil setRectFromCenter:ceilCenter andSize:ceilSize];
    [_skinStairBotBack setRectFromCenter:wallCenter andSize:wallSize];
    [_skinStairBotFront setRectFromCenter:wallCenter andSize:wallSize];
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
    float stairEnd = self->_startCorner.x + STEP_0_WIDTH + STAIR_WIDTH;
    float heightStart = self->_startCorner.y;
    float heightEnd = self->_startCorner.y + STAIR_HEIGHT;
    
    GLKVector2 heroPosition = [[BCGlobalManager manager] heroPosition];
    
    if (xPos > stairEnd) {
        if (heroPosition.y > self->_startCorner.y) {
            return heightEnd;
        } else {
            return heightStart;
        }
    }
    
    return heightStart;
}


@end
