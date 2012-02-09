//
//  AHGraphicsPolygon.h
//  BlackCat
//
//  Created by Tim Wood on 2/8/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsObject.h"


@interface AHGraphicsPolygon : AHGraphicsObject


#pragma mark -
#pragma mark init


- (id)initFromPoints:(GLKVector2 *)points
        andTexPoints:(GLKVector2 *)texPoints
            andCount:(int)count;


#pragma mark -
#pragma mark setters


- (void)setPositionVertices:(GLKVector2 *)verts;
- (void)setTextureVertices:(GLKVector2 *)verts;
- (void)setDisplayAsFan:(BOOL)asFan;


@end
