# IMDrawersMenuController

<img src="http://res.cloudinary.com/foosh/image/upload/v1469638571/drawers_menu_controller_ufhp5q.gif"/>

<b>IMDrawersMenuController</b> is an iOS menu controller with drawers as menu items.

## Requirements

- Requires iOS 7 or later
- Requires Automatic Reference Counting (ARC)

## Demo Project

Please feel free to try the IMDrawersMenuControllerDemo project in Xcode. It demonstrates a simple setup of the menu controller.

## Installation

Simply drag & drop the IMDrawersMenuController folder to your project.

## Usage

IMDrawersMenuController has a very similar usage to UITabBarController. Please see the following steps:

####1. Import the header file

```objective-c
#import "IMDrawersMenuController.h"
```

####2. Initialize the menu controller and set its view controllers

```objective-c
IMDrawersMenuController *menuController = [IMDrawersMenuController new];
menuController.viewControllers = viewControllers;
```

####3. Customize menu items

```objective-c
[menuController.menuView.items enumerateObjectsUsingBlock:^(IMDrawersMenuItem *item, NSUInteger idx, BOOL *stop) {
    item.backgroundColor = yourColor;
    item.font = yourFont;
    item.image = yourNormalImage;
    item.highlightedImage = yourSelectedImage;
    item.highlightedTextColor = yourHighlightedTextColor;
    item.textColor = yourNormalTextColor;
}];
```

####4. Set the menu controller as window's root view controller

```objective-c
_window.rootViewController = menuController;
```

## License

IMDrawersMenuController is available under the MIT license. See the LICENSE file for more info.
