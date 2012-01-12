//
//  BCTerrainBuilder.h
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActor.h"


@interface BCTerrainBuilder : AHActor {
@private;
    float _distanceCovered;
}


#pragma mark -
#pragma mark build


- (void)buildBuilding;


@end
