//
//  AHPhysicsManagerCPP.mm
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <GLKit/GLKit.h>

#import "AHGraphicsManager.h"
#import "AHTimeManager.h"
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
    
    // contacts
    _contactListener = new AHContactListener();
    _world->SetContactListener(_contactListener);
}


#pragma mark -
#pragma mark update


- (void)update {
    _world->Step([[AHTimeManager manager] worldSecondsPerFrame], 10, 10);
}


#pragma mark -
#pragma mark draw


- (void)drawDebug {
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    [[AHGraphicsManager camera] prepareToDrawWorldOrtho];
    
    if (_world) {
        _world->DrawDebugData();
    }
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

- (NSMutableArray *)getActorsAtPoint:(GLKVector2)point withSize:(GLKVector2)size {
    b2AABB aabb;
	b2Vec2 _size = b2Vec2(size.x, size.y);
 	b2Vec2 _point = b2Vec2(point.x, point.y);
    
	aabb.lowerBound = _point - _size;
	aabb.upperBound = _point + _size;
	
	ManyQueryCallback callback(_point);
	_world->QueryAABB(&callback, aabb);
	
    return callback.actors;
}

class RayCastCallback : public b2RayCastCallback {
public:
    RayCastCallback(int tag) {
        _tag = tag;
        category = 0;
    }
    
    float32 ReportFixture(b2Fixture* fixture, 
                          const b2Vec2& point,
                          const b2Vec2& normal, 
                          float32 fraction) {
        AHPhysicsBody *body = (__bridge AHPhysicsBody *) fixture->GetBody()->GetUserData();
        if (_tag > 0 && ![body hasTag:_tag]) { // ignore if we have a desired tag and this body does not have the tag;
            return -1;
        } else {
            category = [body category];
            return 0;
        }
    }
    
    int _tag;
	int category;
};

- (int)getFirstActorCategoryFrom:(GLKVector2)pointA to:(GLKVector2)pointB {
	return [self getFirstActorCategoryWithTag:0 from:pointA to:pointB];
}

- (int)getFirstActorCategoryWithTag:(int)tag from:(GLKVector2)pointA to:(GLKVector2)pointB {
    RayCastCallback callback(tag);
	[self world]->RayCast(&callback, 
                          b2Vec2(pointA.x, pointA.y), 
                          b2Vec2(pointB.x, pointB.y));
    return callback.category;
}

@end
