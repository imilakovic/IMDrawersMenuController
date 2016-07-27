//
//  IMDrawersMenuView.h
//
//  Copyright © 2016 Igor Milakovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMDrawersMenuItem;

@protocol IMDrawersMenuViewDelegate;

@interface IMDrawersMenuView : UIView

@property (weak, nonatomic) id<IMDrawersMenuViewDelegate> delegate;
@property (copy, nonatomic) NSArray *items;
@property (weak, nonatomic) IMDrawersMenuItem *selectedItem;

- (void)performAnimationWithDuration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)())completion;
- (void)prepareForAnimation;

@end


@protocol IMDrawersMenuViewDelegate <NSObject>

- (void)menuView:(IMDrawersMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index;

@end
