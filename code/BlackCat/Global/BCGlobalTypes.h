//
//  BCGlobalTypes.h
//  BlackCat
//
//  Created by Tim Wood on 1/13/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


typedef enum {
    MSG_HERO_JUMP,
    MSG_HERO_LAND
} BCActorMessageType;


typedef enum {
    PHY_CAT_NONE,
    PHY_CAT_BUILDING,
    PHY_CAT_HERO,
    PHY_CAT_BOX
} BCPhysicsBodyCategories;


typedef enum {
    PHY_TAG_NONE        = 0x0000,
    PHY_TAG_JUMPABLE    = 0x0001,
    PHY_TAG_DEBRIS      = 0x0002
} BCPhysicsBodyTypes;


typedef enum {
    GFX_LAYER_BACKGROUND,
    GFK_LAYER_BUILDINGS,
    GFK_LAYER_HERO
} BCGraphicsLayers;