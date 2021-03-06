//
//  BCGlobalTypes.h
//  BlackCat
//
//  Created by Tim Wood on 1/13/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


typedef enum {
    MSG_HERO_JUMP,
    MSG_HERO_LAND,
    MSG_EXPLOSION_ALL,
    MSG_EXPLOSION_DOWN,
    MSG_EXPLOSION_UP,
    MSG_EXPLOSION_RIGHT
} BCActorMessageType;


typedef enum {
    PHY_CAT_NONE      = 0x0000,
    PHY_CAT_DEFAULT   = 0x0001,
    PHY_CAT_BUILDING  = 0x0002,
    PHY_CAT_HERO      = 0x0004,
    PHY_CAT_BOX       = 0x0008,
    PHY_CAT_CRASHABLE = 0x0010,
    PHY_CAT_DEBRIS    = 0x0020
} BCPhysicsBodyCategories;


typedef enum {
    PHY_TAG_NONE          = 0x0000,
    PHY_TAG_JUMPABLE      = 0x0001,
    PHY_TAG_DEBRIS        = 0x0002,
    PHY_TAG_CRASHABLE     = 0x0004,
    PHY_TAG_PHASEWALKABLE = 0x0008,
    PHY_TAG_BREAKABLE     = 0x0010,
    PHY_TAG_ONE_WAY_FLOOR = 0x0020
} BCPhysicsBodyTypes;


// front should be near the top to take advantage of depth buffering
typedef enum {
    GFK_LAYER_BUILDINGS,
    GFX_LAYER_BACKGROUND,
    GFK_LAYER_HERO
} BCGraphicsLayers;


typedef enum {
    HERO_TYPE_DETECTIVE,
    HERO_TYPE_FEMME,
    HERO_TYPE_BOXER
} BCHeroTypes;


// z index
#define Z_NEAR_LIMIT 2.0f
#define Z_FAR_LIMIT 30.0f

#define Z_WALL_WIDTH     -0.2f

#define Z_LIGHT          0.0f

#define Z_BUILDING_FRONT -4.0f
#define Z_STAIR_FRONT    -5.5f
#define Z_PHYSICS_FRONT  -5.9f
#define Z_PHYSICS_DEPTH  -6.0f
#define Z_PHYSICS_BACK   -6.1f
#define Z_STAIR_BACK     -6.5f
#define Z_BUILDING_BACK  -8.0f

#define Z_BACKGROUND_1   -10.0f
#define Z_BACKGROUND_2   -15.0f
#define Z_BACKGROUND_3   -20.0f
#define Z_BACKGROUND_4   -30.0f

// hero
#define HERO_WIDTH 0.3f
#define HERO_HEIGHT 1.0f
#define HERO_HEIGHT_RAYCAST_RADIUS_RATIO 1.1f
#define HERO_WIDTH_RAYCAST_RADIUS_RATIO 1.5f




#define DEBUGGING_CAMERA NO








