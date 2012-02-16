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


#define Z_NEAR_LIMIT 0.5f
#define Z_FAR_LIMIT 15.0f


#define Z_BUILDING_FRONT -3.0f
#define Z_STAIR_FRONT    -3.5f
#define Z_PHYSICS_FRONT  -3.9f
#define Z_PHYSICS_DEPTH  -4.0f
#define Z_PHYSICS_BACK   -4.1f
#define Z_STAIR_BACK     -4.5f
#define Z_BUILDING_BACK  -5.0f







