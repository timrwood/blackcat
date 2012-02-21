//
//  AHGraphicsObject.h
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHGraphicsVertexStruct.h"
#import "AHActorComponent.h"
#import "AHTextureInfo.h"


@class AHGraphicsLayer;


@interface AHGraphicsObject : AHActorComponent {
@private;
    AHGraphicsLayer *_layer;
    AHTextureInfo *_baseTexture;
    AHTextureInfo *_normalTexture;
    
    int _indexCount;
    int _count;
    int _layerIndex;
    BOOL _isForHud;
    
    BOOL _isOffset;
    
    GLuint _bufferId;
    GLuint _arrayId;
@protected;
    AHVertex *vertices;
    GLubyte *indices;
    
    GLKVector2 _position;
    float _rotation;
    
    GLenum _drawStaticDynamic;
    GLenum _drawType;
}


#pragma mark -
#pragma mark cache


- (void)setDynamicBuffer:(BOOL)dynamicBuffer;
- (void)bufferVertices;
- (void)bufferIndices;


#pragma mark -
#pragma mark layer


- (void)setHudLayer:(BOOL)isForHud;
- (void)setLayerIndex:(int)i;
- (void)setLayer:(AHGraphicsLayer *)layer;
- (void)removeFromParentLayer;


#pragma mark -
#pragma mark vertices


- (void)setVertexCount:(int)newCount;
- (void)setIndexCount:(int)newCount;
- (int)vertexCount;
- (void)calculateTangentAndBinormals;


#pragma mark -
#pragma mark offset


- (void)setPosition:(GLKVector2)position;
- (GLKVector2)position;
- (void)setRotation:(float)rotation;


#pragma mark -
#pragma mark textures


- (void)setNormalTextureKey:(NSString *)key;
- (void)setTextureKey:(NSString *)key;
- (AHTextureInfo *)baseTexture;
- (AHTextureInfo *)normalTexture;


#pragma mark -
#pragma mark draw


- (void)draw;
- (void)drawActual;
- (void)setDrawType:(GLenum)drawType;


#pragma mark -
#pragma mark update


- (void)update;


@end
