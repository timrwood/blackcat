//
//  AHPhysicsPolygon.h
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsBody.h"


@interface AHPhysicsPolygon : AHPhysicsBody {
@private;
    int _count;
    b2Vec2 *_points;
    
    GLKVector2 _position;
    
    float _rotation;
    
    BOOL _isLooped;
    BOOL _isEdge;
}


#pragma mark -
#pragma mark init


- (id)initFromPoints:(GLKVector2 *)points 
            andCount:(int)count;
- (id)initFromPoints:(GLKVector2 *)points 
            andCount:(int)count 
         andPosition:(GLKVector2)position;

         
#pragma mark -
#pragma mark setters
         
         
- (void)setPoints:(GLKVector2 *)points andCount:(int)count;
- (void)setLooped:(BOOL)looped;
- (void)setEdge:(BOOL)edge;


@end
