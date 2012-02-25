//
//  SKPoseView.m
//  Skeletons
//
//  Created by Tim Wood on 2/24/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "SKPoseJoint.h"
#import "SKPoseView.h"


@implementation SKPoseView


#pragma mark -
#pragma mark init


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        joints = [[NSMutableArray alloc] init];
        [self initJoints];
    }
    return self;
}

- (void)initJoints {
    waist = [[SKPoseJoint alloc] init];
    neck = [[SKPoseJoint alloc] init];
    
    elbow1 = [[SKPoseJoint alloc] init];
    elbow2 = [[SKPoseJoint alloc] init];
    
    shoulder1 = [[SKPoseJoint alloc] init];
    shoulder2 = [[SKPoseJoint alloc] init];
    
    knee1 = [[SKPoseJoint alloc] init];
    knee2 = [[SKPoseJoint alloc] init];
    
    hip1 = [[SKPoseJoint alloc] init];
    hip2 = [[SKPoseJoint alloc] init];
    
    [self addJoint:waist];
    [self addJoint:neck];
    
    [self addJoint:elbow1];
    [self addJoint:elbow2];
    
    [self addJoint:shoulder1];
    [self addJoint:shoulder2];
    
    [self addJoint:knee1];
    [self addJoint:knee2];
    
    [self addJoint:hip1];
    [self addJoint:hip2];
    
    [neck setParent:waist];
    
    [elbow1 setParent:shoulder1];
    [elbow2 setParent:shoulder2];
    
    [shoulder1 setParent:waist];
    [shoulder2 setParent:waist];
    
    [hip1 setParent:waist];
    [hip2 setParent:waist];
    
    [knee1 setParent:hip1];
    [knee2 setParent:hip2];
    
    [waist setPosition:GLKVector2Make(290.0f, 145.0f)];
    [neck setPosition:GLKVector2Make(0.0f, 80.0f)];
    [waist setLength:GLKVector2Make(0.0f, 80.0f)];
    [neck setLength:GLKVector2Make(0.0f, 40.0f)]; 
    
    [hip1 setPosition:GLKVector2Make(0.0f, 0.0f)];
    [hip2 setPosition:GLKVector2Make(0.0f, 0.0f)];
    [hip1 setLength:GLKVector2Make(0.0f, -50.0f)];
    [hip2 setLength:GLKVector2Make(0.0f, -50.0f)];
    
    [knee1 setPosition:GLKVector2Make(0.0f, -50.0f)];
    [knee2 setPosition:GLKVector2Make(0.0f, -50.0f)];
    [knee1 setLength:GLKVector2Make(0.0f, -50.0f)];
    [knee2 setLength:GLKVector2Make(0.0f, -50.0f)];
    
    [elbow1 setPosition:GLKVector2Make(0.0f, -50.0f)];
    [elbow2 setPosition:GLKVector2Make(0.0f, -50.0f)];
    [elbow1 setLength:GLKVector2Make(0.0f, -50.0f)];
    [elbow2 setLength:GLKVector2Make(0.0f, -50.0f)];
    
    [shoulder1 setPosition:GLKVector2Make(0.0f, 80.0f)];
    [shoulder2 setPosition:GLKVector2Make(0.0f, 80.0f)];
    [shoulder1 setLength:GLKVector2Make(0.0f, -50.0f)];
    [shoulder2 setLength:GLKVector2Make(0.0f, -50.0f)];
}


#pragma mark -
#pragma mark dragging


- (BOOL)acceptsFirstMouse:(NSEvent *)event {
	return YES;
}

- (void)mouseDown:(NSEvent *)event {
    CGPoint l = [event locationInWindow];
    CGRect r = [self convertRect:[self bounds] toView:nil];
    l.x -= r.origin.x;
    l.y -= r.origin.y;
    GLKVector2 g = GLKVector2Make(l.x, l.y);
    
    [self jointClosestToPoint:g];
    
    NSLog(@"location %F %F", g.x, g.y);
}

- (void)mouseDragged:(NSEvent *)event {
    CGPoint l = [event locationInWindow];
    CGRect r = [self convertRect:[self bounds] toView:nil];
    l.x -= r.origin.x;
    l.y -= r.origin.y;
    GLKVector2 g = GLKVector2Make(l.x, l.y);
    
    [current rotateTowardsPoint:g];
    
    [self setNeedsDisplay:YES];
    
    NSLog(@"drag location %F %F", g.x, g.y);
}

- (void)mouseUp:(NSEvent *)event {
    
}


#pragma mark -
#pragma mark draw


- (void)drawRect:(NSRect)dirtyRect {
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGFloat color[4];
    color[0] = 0.0f;
    color[1] = 1.0f;
    color[2] = 1.0f;
    color[3] = 0.5f;
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 10.0f);
    CGContextSetStrokeColor(context, color);
    for (SKPoseJoint *joint in joints) {
        [joint drawInContext:context];
    }
}


#pragma mark -
#pragma mark joints


- (void)addJoint:(SKPoseJoint *)joint {
    if (![joints containsObject:joint]) {
        [joints addObject:joint];
    }
}

- (void)jointClosestToPoint:(GLKVector2)point {
    float dist = 100000.0f;
    float newDist;
    for (SKPoseJoint *joint in joints) {
        newDist = GLKVector2Length(GLKVector2Subtract(point, [joint endPoint]));
        if (newDist < dist) {
            current = joint;
            dist = newDist;
        }
    }
}


#pragma mark -
#pragma mark debug


- (void)debugRotation {
    _r += 0.01;
    [waist setRotation:_r];
    [neck setRotation:_r];
    [elbow1 setRotation:_r];
    [elbow2 setRotation:-_r];
    [shoulder1 setRotation:-_r];
    [shoulder2 setRotation:_r];
    [knee1 setRotation:_r];
    [knee2 setRotation:-_r];
    [hip1 setRotation:-_r];
    [hip2 setRotation:_r];
    
    [self setNeedsDisplay:YES];
}


@end
