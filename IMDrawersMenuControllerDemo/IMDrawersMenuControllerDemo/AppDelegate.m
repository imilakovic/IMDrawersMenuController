//
//  AppDelegate.m
//  IMDrawersMenuControllerDemo
//
//  Created by Igor Milakovic on 27/07/16.
//  Copyright © 2016 Igor Milakovic. All rights reserved.
//

#import "AppDelegate.h"

#import "IMDrawersMenuController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end


@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSArray *colors = @[RGB_COLOR(222, 57, 20),
                        RGB_COLOR(222, 128, 20),
                        RGB_COLOR(222, 185, 20),
                        RGB_COLOR(109, 194, 23),
                        RGB_COLOR(23, 83, 194)];
    
    NSMutableArray *viewControllers = [NSMutableArray new];
    [colors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx, BOOL *stop) {
        NSString *title = [NSString stringWithFormat:@"View Controller %li", (long)idx + 1];
        
        ViewController *viewController = [ViewController new];
        viewController.navigationItem.title = title;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navigationController.navigationBar.shadowImage = [UIImage new];
        navigationController.navigationBar.tintColor = RGB_COLOR(250, 250, 250);
        navigationController.navigationBar.translucent = NO;
        [navigationController.navigationBar setBackgroundImage:[self imageWithColor:colors.lastObject] forBarMetrics:UIBarMetricsDefault];
        [navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: RGB_COLOR(250, 250, 250)}];
        navigationController.title = title;
        
        [viewControllers addObject:navigationController];
    }];
    
    IMDrawersMenuController *menuController = [IMDrawersMenuController new];
    menuController.closeAnimationDuration = 0.5;
    menuController.openAnimationDuration = 0.3;
    menuController.viewControllers = viewControllers;
    [menuController.menuView.items enumerateObjectsUsingBlock:^(IMDrawersMenuItem *item, NSUInteger idx, BOOL *stop) {
        item.backgroundColor = colors[idx];
        item.font = [UIFont boldSystemFontOfSize:17.0];
        item.highlightedTextColor = RGB_COLOR(250, 250, 250);
        item.textColor = RGB_COLOR(25, 28, 33);
    }];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = menuController;
    [_window makeKeyAndVisible];
    
    return YES;
}


#pragma mark - Helpers

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
