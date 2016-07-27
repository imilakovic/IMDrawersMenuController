//
//  IMDrawersMenuController.h
//
//  Copyright © 2016 Igor Milakovic. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#import "IMDrawersMenuItem.h"
#import "IMDrawersMenuView.h"

@protocol IMDrawersMenuControllerDelegate;

@interface IMDrawersMenuController : UIViewController

/**
 Array of view controllers.
 */
@property (copy, nonatomic) NSArray *viewControllers;

/**
 Menu controller delegate.
 */
@property (weak, nonatomic) id<IMDrawersMenuControllerDelegate> delegate;

/**
 Menu view of the Menu controller.
 */
@property (strong, nonatomic) IMDrawersMenuView *menuView;

/**
 Selected view controller index.
 */
@property (nonatomic) NSUInteger selectedIndex;

/**
 Opening animation duration (per drawer).
 Default value is 0.2 seconds.
 */
@property (assign, nonatomic) NSTimeInterval openAnimationDuration;

/**
 Closing animation duration.
 Default value is 0.3 seconds.
 */
@property (assign, nonatomic) NSTimeInterval closeAnimationDuration;

/**
 Class of a view controller that should be excluded from the menu view.
 For example, it may be an initial/welcome screen which needs to be shown on startup only.
 */
- (NSString *)excludedViewControllerClass;

/**
 Currently selected view controller.
 */
- (UIViewController *)selectedViewController;

/**
 Open/close the menu view.
 */
- (void)toggleMenuView;

@end


@protocol IMDrawersMenuControllerDelegate <NSObject>

@optional
- (void)menuControllerWillPresentMenuView:(IMDrawersMenuController *)menuController;
- (void)menuControllerDidPresentMenuView:(IMDrawersMenuController *)menuController;
- (void)menuControllerWillDismissMenuView:(IMDrawersMenuController *)menuController;
- (void)menuControllerDidDismissMenuView:(IMDrawersMenuController *)menuController;

@end


@interface UIViewController (IMDrawersMenuController)

/**
 Accessor for menu controller from its child view controllers.
 */
@property (readonly, nonatomic) IMDrawersMenuController *im_menuController;

@end
