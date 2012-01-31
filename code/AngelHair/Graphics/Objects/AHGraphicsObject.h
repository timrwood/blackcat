//
//  AHGraphicsObject.h
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActorComponent.h"
#import "AHTextureInfo.h"


@class AHGraphicsLayer;


@interface AHGraphicsObject : AHActorComponent {
@private;
    AHGraphicsLayer *_layer;
    AHTextureInfo *_texture;
    
    int _count;
    
    BOOL _isOffset;
@protected;
    GLKVector2 *vertices;
    GLKVector2 *textures;
    
    GLKVector2 _position;
    float _rotation;
}


#pragma mark -
#pragma mark layer


- (void)addToLayerIndex:(int)i;
- (void)setLayer:(AHGraphicsLayer *)layer;
- (void)removeFromParentLayer;


#pragma mark -
#pragma mark vertices


- (void)setVertexCount:(int)newCount;


#pragma mark -
#pragma mark offset


- (void)setPosition:(GLKVector2)position;
- (void)setRotation:(float)rotation;


#pragma mark -
#pragma mark textures


- (void)setTextureKey:(NSString *)key;
- (AHTextureInfo *)texture;


#pragma mark -
#pragma mark draw


- (void)draw;


#pragma mark -
#pragma mark update


- (void)update;


@end
