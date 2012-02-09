//
//  AHGraphicsObject.h
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHActorComponent.h"
#import "AHTextureInfo.h"


@class AHGraphicsLayer;


@interface AHGraphicsObject : AHActorComponent {
@private;
    AHGraphicsLayer *_layer;
    AHTextureInfo *_texture;
    
    int _count;
    int _layerIndex;
    BOOL _isForHud;
    
    BOOL _isOffset;
@protected;
    GLKVector2 *vertices;
    GLKVector2 *textures;
    
    GLKVector2 _position;
    float _rotation;
    
    GLenum _drawType;
}


#pragma mark -
#pragma mark layer


- (void)setHudLayer:(BOOL)isForHud;
- (void)setLayerIndex:(int)i;
- (void)setLayer:(AHGraphicsLayer *)layer;
- (void)removeFromParentLayer;


#pragma mark -
#pragma mark vertices


- (void)setVertexCount:(int)newCount;
- (int)vertexCount;


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
- (void)setDrawType:(GLenum)drawType;


#pragma mark -
#pragma mark update


- (void)update;


@end
