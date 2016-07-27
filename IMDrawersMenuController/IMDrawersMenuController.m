//
//  IMDrawersMenuController.m
//
//  Copyright © 2016 Igor Milakovic. All rights reserved.
//

#import "IMDrawersMenuController.h"

@interface UIViewController (IMDrawersMenuControllerInternal)

- (void)im_setMenuController:(IMDrawersMenuController *)menuController;

@end


@interface IMDrawersMenuController () <IMDrawersMenuViewDelegate>

@property (assign, nonatomic) BOOL firstAppearance;
@property (assign, nonatomic) BOOL menuViewVisible;

@property (strong, nonatomic) UIView *contentView;

@end


@implementation IMDrawersMenuController

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        _openAnimationDuration = 0.2;
        _closeAnimationDuration = 0.3;
    }
    return self;
}


#pragma mark - UIViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.selectedViewController.preferredStatusBarStyle;
}


- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.selectedViewController.preferredStatusBarUpdateAnimation;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskAll;
    for (UIViewController *viewController in _viewControllers) {
        if (![viewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
            return UIInterfaceOrientationMaskPortrait;
        }
        
        UIInterfaceOrientationMask supportedOrientations = viewController.supportedInterfaceOrientations;
        if (orientationMask > supportedOrientations) {
            orientationMask = supportedOrientations;
        }
    }
    
    return orientationMask;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    for (UIViewController *viewCotroller in _viewControllers) {
        if (![viewCotroller respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)] ||
            ![viewCotroller shouldAutorotateToInterfaceOrientation:toInterfaceOrientation]) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - Public

- (NSString *)excludedViewControllerClass {
    return nil;
}


- (UIViewController *)selectedViewController {
    return _viewControllers[_selectedIndex];
}


- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex >= _viewControllers.count) {
        return;
    }
    
    if (self.selectedViewController) {
        [self.selectedViewController willMoveToParentViewController:nil];
        [self.selectedViewController.view removeFromSuperview];
        [self.selectedViewController removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    if (_selectedIndex < self.menuView.items.count) {
        self.menuView.selectedItem = self.menuView.items[_selectedIndex];
    }
    
    [self addChildViewController:self.selectedViewController];
    self.selectedViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.selectedViewController.view];
    [self.selectedViewController didMoveToParentViewController:self];
    
    [self setNeedsStatusBarAppearanceUpdate];
}


- (void)setViewControllers:(NSArray *)viewControllers {
    if (_viewControllers && _viewControllers.count) {
        for (UIViewController *viewController in _viewControllers) {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]] && viewControllers.count > 0) {
        _viewControllers = nil;
        _viewControllers = [viewControllers copy];
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (UIViewController *viewController in _viewControllers) {
            if (![viewController isKindOfClass:NSClassFromString(self.excludedViewControllerClass)]) {
                IMDrawersMenuItem *item = [IMDrawersMenuItem new];
                item.title = viewController.title;
                [items addObject:item];
            }
            [viewController im_setMenuController:self];
        }
        
        self.menuView.items = items;
    } else {
        for (UIViewController *viewController in _viewControllers) {
            [viewController im_setMenuController:nil];
        }
        
        _viewControllers = nil;
    }
}


- (void)toggleMenuView {
    if (_menuViewVisible) {
        // Close animation
        if ([_delegate respondsToSelector:@selector(menuControllerWillDismissMenuView:)]) {
            [_delegate menuControllerWillDismissMenuView:self];
        }
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:_closeAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.menuView.frame = CGRectMake(0.0, -self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
            self.contentView.frame = self.view.bounds;
        } completion:^(BOOL finished) {
            if ([_delegate respondsToSelector:@selector(menuControllerDidDismissMenuView:)]) {
                [_delegate menuControllerDidDismissMenuView:self];
            }
            _menuViewVisible = NO;
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    } else {
        // Open animation
        if ([_delegate respondsToSelector:@selector(menuControllerWillPresentMenuView:)]) {
            [_delegate menuControllerWillPresentMenuView:self];
        }
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self.menuView prepareForAnimation];
        
        NSTimeInterval duration = _openAnimationDuration;
        UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
        [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
            self.contentView.frame = CGRectMake(0.0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
            self.menuView.frame = self.view.bounds;
        } completion:^(BOOL finished) {
            [self.menuView performAnimationWithDuration:duration options:options completion:^{
                if ([_delegate respondsToSelector:@selector(menuControllerDidPresentMenuView:)]) {
                    [_delegate menuControllerDidPresentMenuView:self];
                }
                _menuViewVisible = YES;
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }];
        }];
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.menuView];
    
    _firstAppearance = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_firstAppearance) {
        return;
    }
    
    self.selectedIndex = self.excludedViewControllerClass ? _viewControllers.count - 1 : 0;
    
    _firstAppearance = NO;
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.contentView.frame = self.view.bounds;
    self.menuView.frame = CGRectMake(0.0, -self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
}


#pragma mark - UI

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    return _contentView;
}


- (IMDrawersMenuView *)menuView {
    if (!_menuView) {
        _menuView = [IMDrawersMenuView new];
        _menuView.delegate = self;
    }
    return _menuView;
}


#pragma mark - IMDrawersMenuViewDelegate

- (void)menuView:(IMDrawersMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index {
    if (_selectedIndex != index) {
        self.selectedIndex = index;
    }
    
    [self toggleMenuView];
}


@end


@implementation UIViewController (IMDrawersMenuControllerInternal)

- (void)im_setMenuController:(IMDrawersMenuController *)menuController {
    objc_setAssociatedObject(self, @selector(im_menuController), menuController, OBJC_ASSOCIATION_ASSIGN);
}


@end


@implementation UIViewController (IMDrawersMenuController)

- (IMDrawersMenuController *)im_menuController {
    IMDrawersMenuController *menuController = objc_getAssociatedObject(self, @selector(im_menuController));
    if (!menuController && self.parentViewController) {
        menuController = self.parentViewController.im_menuController;
    }
    
    return menuController;
}


@end
