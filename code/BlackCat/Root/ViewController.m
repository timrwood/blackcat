//
//  ViewController.m
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "ViewController.h"
#import "AHSuperSystem.h"
#import "AHGraphicsManager.h"

#import "AHActorManager.h"
#import "DebugActor.h"


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // debug 
    [[AHActorManager manager] add:[[DebugActor alloc] init]];
    
    _context = [[AHGraphicsManager manager] context];
    
    GLKView *view = (GLKView *) self.view;
    view.context = _context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;

}

- (void)viewDidUnload {    
    [super viewDidUnload];
    
    if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[AHSuperSystem manager] cleanCache];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


#pragma mark -
#pragma mark update


- (void)update {
    [[AHSuperSystem manager] update];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [[AHSuperSystem manager] draw];
}


@end
