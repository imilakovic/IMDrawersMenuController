//
//  IMDrawersMenuItem.m
//
//  Copyright © 2016 Igor Milakovic. All rights reserved.
//

#import "IMDrawersMenuItem.h"

@interface IMDrawersMenuItem ()

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;

@end


@implementation IMDrawersMenuItem

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(handleControlEventTouchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(handleControlEventTouchUp) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        
        _contentView = [UIView new];
        _contentView.userInteractionEnabled = NO;
        [self addSubview:_contentView];
        
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeCenter;
        [_contentView addSubview:_imageView];
        
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_titleLabel];
        
        _imageWidth = 56.0;
    }
    return self;
}

#pragma mark - Inheriting

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    _imageView.highlighted = selected;
    _titleLabel.textColor = selected ? _highlightedTextColor : _textColor;
}


#pragma mark - Public

- (void)setFont:(UIFont *)font {
    _font = nil;
    _font = font;
    
    _titleLabel.font = _font;
}


- (void)setHighlightedImage:(UIImage *)highlightedImage {
    _highlightedImage = nil;
    _highlightedImage = highlightedImage;
    
    _imageView.highlightedImage = _highlightedImage;
}


- (void)setImage:(UIImage *)image {
    _image = nil;
    _image = image;
    
    _imageView.image = _image;
}


- (void)setTextColor:(UIColor *)textColor {
    _textColor = nil;
    _textColor = textColor;
    
    _titleLabel.textColor = self.selected ? _highlightedTextColor : _textColor;
}


- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor {
    _highlightedTextColor = nil;
    _highlightedTextColor = highlightedTextColor;
    
    _titleLabel.textColor = self.selected ? _highlightedTextColor : _textColor;
}


- (void)setTitle:(NSString *)title {
    _title = nil;
    _title = title;
    
    _titleLabel.text = _title;
}


#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _contentView.frame = CGRectMake(0.0, self.bounds.size.height - _contentHeight, self.bounds.size.width, _contentHeight);
    
    CGSize size = _contentView.bounds.size;
    
    if ((_imageView.image || _imageView.highlightedImage) && _titleLabel.text.length == 0) {
        _imageView.frame = _contentView.bounds;
    } else if (!_imageView.image && !_imageView.highlightedImage && _titleLabel.text.length > 0) {
        CGFloat verticalMargin = 20.0;
        _titleLabel.frame = CGRectMake(verticalMargin, 0.0, size.width - verticalMargin * 2.0, size.height);
    } else {
        _imageView.frame = CGRectMake(0.0, 0.0, _imageWidth, size.height);
        _titleLabel.frame = CGRectMake(_imageWidth, 0.0, size.width - _imageWidth * 2.0, size.height);
    }
}


- (void)setContentHeight:(CGFloat)contentHeight {
    _contentHeight = contentHeight;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (void)setImageWidth:(CGFloat)imageWidth {
    _imageWidth = imageWidth;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


#pragma mark - Control events

- (void)handleControlEventTouchDown {
    _contentView.alpha = 0.3;
}


- (void)handleControlEventTouchUp {
    [UIView animateWithDuration:0.25 animations:^{
        _contentView.alpha = 1.0;
    }];
}


@end
