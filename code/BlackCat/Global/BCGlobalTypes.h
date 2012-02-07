//
//  BCGlobalTypes.h
//  BlackCat
//
//  Created by Tim Wood on 1/13/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


typedef enum {
    MSG_HERO_JUMP,
    MSG_HERO_LAND
} BCActorMessageType;


typedef enum {
    PHY_CAT_NONE,
    PHY_CAT_BUILDING,
    PHY_CAT_HERO,
    PHY_CAT_BOX,
    PHY_CAT_CRASHABLE
} BCPhysicsBodyCategories;


typedef enum {
    PHY_TAG_NONE          = 0x0000,
    PHY_TAG_JUMPABLE      = 0x0001,
    PHY_TAG_DEBRIS        = 0x0002,
    PHY_TAG_CRASHABLE     = 0x0004,
    PHY_TAG_PHASEWALKABLE = 0x0008,
    PHY_TAG_BREAKABLE     = 0x0010
} BCPhysicsBodyTypes;


typedef enum {
    GFX_LAYER_BACKGROUND,
    GFK_LAYER_BUILDINGS,
    GFK_LAYER_HERO
} BCGraphicsLayers;


typedef enum {
    HERO_TYPE_DETECTIVE,
    HERO_TYPE_FEMME,
    HERO_TYPE_BOXER
} BCHeroTypes;