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
@protected;
    GLKVector2 *vertices;
    GLKVector2 *textures;
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
