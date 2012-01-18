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
#import "AHInputManager.h"
#import "AHSceneManager.h"

#import "BCMainScene.h"


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // debug
    [[AHSceneManager manager] goToScene:[[BCMainScene alloc] init]];
    
    _context = [[AHGraphicsManager manager] context];
    
    GLKView *view = (GLKView *) self.view;
    view.context = _context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableMultisample = GLKViewDrawableMultisample4X;

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
#pragma mark touches


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [[AHInputManager manager] touchBegan:touch];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [[AHInputManager manager] touchMoved:touch];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [[AHInputManager manager] touchEnded:touch];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
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
