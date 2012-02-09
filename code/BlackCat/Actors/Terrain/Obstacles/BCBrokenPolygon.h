//
//  BCBrokenPolygon.h
//  BlackCat
//
//  Created by Tim Wood on 2/8/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsPolygon.h"
#import "AHActor.h"


@class AHPhysicsPolygon;


@interface BCBrokenPolygon : AHActor {
@private;
    AHPhysicsPolygon *_body;
    AHGraphicsPolygon *_skin;
}


#pragma mark -
#pragma mark init


- (id)initFromQuad:(AHPolygonQuad)quad
        andTexQuad:(AHPolygonQuad)texQuad
     andTextureKey:(NSString *)texKey;


@end
