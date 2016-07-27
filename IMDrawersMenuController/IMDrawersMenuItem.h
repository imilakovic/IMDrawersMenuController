//
//  IMDrawersMenuItem.h
//
//  Copyright © 2016 Igor Milakovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMDrawersMenuItem : UIControl

@property (assign, nonatomic) CGFloat contentHeight;
@property (assign, nonatomic) CGFloat imageWidth;

@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *highlightedImage;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *highlightedTextColor;

@end
