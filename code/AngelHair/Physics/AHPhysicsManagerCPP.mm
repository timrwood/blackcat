//
//  AHPhysicsManagerCPP.mm
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsManagerCPP.h"
#import "AHPhysicsBody.h"


@implementation AHPhysicsManagerCPP


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark world


- (b2World *)world {
    return _world;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    _world = new b2World(b2Vec2(0.0f, 10.0f));
    
    // debug draw
    _debugDraw = new AHDebugDraw();
    _debugDraw->SetFlags(AHDebugDraw::e_shapeBit + AHDebugDraw::e_jointBit + AHDebugDraw::e_centerOfMassBit);
    _world->SetDebugDraw(_debugDraw);
}


#pragma mark -
#pragma mark update


- (void)update {
    _world->Step(1.0f / 30.0f, 10, 10);
}


#pragma mark -
#pragma mark draw


- (void)drawDebug {
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_COLOR_MATERIAL);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glLoadIdentity();
    
    if (_world) {
        _world->DrawDebugData();
    }
    
    glDisable(GL_COLOR_MATERIAL);
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    
}


#pragma mark -
#pragma mark query


class ManyQueryCallback : public b2QueryCallback {
public:
	ManyQueryCallback(const b2Vec2& point) {
		actors = [NSMutableArray array];
	}
	
	bool ReportFixture(b2Fixture* fixture) {
		[actors addObject:(__bridge AHPhysicsBody *) fixture->GetBody()->GetUserData()];
		return true;
	}
	
	NSMutableArray* actors;
};

- (NSMutableArray *)getActorsAtPoint:(CGPoint)point withSize:(CGPoint)size {
    b2AABB aabb;
	b2Vec2 _size = b2Vec2(size.x, size.y);
 	b2Vec2 _point = b2Vec2(point.x, point.y);
    
	aabb.lowerBound = _point - _size;
	aabb.upperBound = _point + _size;
	
	ManyQueryCallback callback(_point);
	_world->QueryAABB(&callback, aabb);
	
    return callback.actors;
}


@end
