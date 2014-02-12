//
//  AppDelegate.h
//  CameraApp
//
//  Created by Rienk Woudwijk on 04-02-14.
//  Copyright (c) 2014 Vignet'D. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;

@end
