//
//  AppDelegate.h
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BCViewController;


@interface BCAppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BCViewController *viewController;


@end
