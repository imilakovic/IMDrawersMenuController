//
//  IMDrawersMenuView.m
//
//  Copyright © 2016 Igor Milakovic. All rights reserved.
//

#import "IMDrawersMenuView.h"

#import "IMDrawersMenuItem.h"

@implementation IMDrawersMenuView

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}


#pragma mark - Public

- (void)performAnimationWithDuration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)())completion {
    if (_items.count == 1 && completion) {
        completion();
        return;
    }
    
    NSInteger count = _items.count - 1;
    for (NSInteger i = 0; i < count; i++) {
        NSInteger index = count - 1 - i;
        NSTimeInterval delay = i * duration;
        IMDrawersMenuItem *item = _items[index];
        [UIView animateWithDuration:duration delay:delay options:options animations:^{
            CGRect frame = item.frame;
            frame.origin.y = 0.0;
            item.frame = frame;
        } completion:^(BOOL finished) {
            if (i == count - 1 && completion) {
                completion();
            }
        }];
    }
}


- (void)prepareForAnimation {
    for (NSInteger i = 0; i < _items.count - 1; i++) {
        IMDrawersMenuItem *item = _items[i];
        item.frame = CGRectMake(0.0, -item.frame.size.height, item.frame.size.width, item.frame.size.height);
    }
}


- (void)setItems:(NSArray *)items {
    for (IMDrawersMenuItem *item in _items) {
        [item removeFromSuperview];
    }
    
    _items = nil;
    _items = items.copy;
    
    // Add items in reverse order because of view hierarchy
    for (NSInteger i = _items.count - 1; i >= 0; i--) {
        IMDrawersMenuItem *item = _items[i];
        [item addTarget:self action:@selector(itemTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
    }
}


- (void)setSelectedItem:(IMDrawersMenuItem *)selectedItem {
    if (_selectedItem == selectedItem) {
        return;
    }
    
    [_selectedItem setSelected:NO];
    
    _selectedItem = nil;
    _selectedItem = selectedItem;
    
    [_selectedItem setSelected:YES];
}


#pragma mark - Layout


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat statusBarHeight = 20.0;
    CGFloat itemContentHeight = ceilf((self.bounds.size.height - statusBarHeight) / _items.count);
    [self.items enumerateObjectsUsingBlock:^(IMDrawersMenuItem *item, NSUInteger idx, BOOL *stop) {
        item.contentHeight = itemContentHeight;
        item.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, (idx + 1) * itemContentHeight + statusBarHeight);
    }];
}


#pragma mark - Actions

- (void)itemTapped:(IMDrawersMenuItem *)sender {
    if ([_delegate respondsToSelector:@selector(menuView:didSelectItemAtIndex:)]) {
        NSInteger index = [_items indexOfObject:sender];
        [_delegate menuView:self didSelectItemAtIndex:index];
    }
}


@end
