//
//  ViewController.m
//  IMDrawersMenuControllerDemo
//
//  Created by Igor Milakovic on 27/07/16.
//  Copyright © 2016 Igor Milakovic. All rights reserved.
//

#import "ViewController.h"

#import "IMDrawersMenuController.h"

@interface ViewController ()

@end


@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB_COLOR(240, 240, 240);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuBarButtonItemTapped:)];
}


#pragma mark - Button actions

- (void)menuBarButtonItemTapped:(UIBarButtonItem *)sender {
    [self.im_menuController toggleMenuView];
}


@end
