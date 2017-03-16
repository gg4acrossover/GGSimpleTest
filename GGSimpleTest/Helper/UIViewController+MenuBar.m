//
//  UIViewController+MenuBar.m
//  GGSimpleTest
//
//  Created by VietHQ on 3/10/17.
//  Copyright © 2017 viethq. All rights reserved.
//

#import "UIViewController+MenuBar.h"
#import "MFSideMenu.h"

@implementation UIViewController (MenuBar)

- (void)addHumbergerMenuLeftPosition
{
    UIBarButtonItem *pItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico_left_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(openLeftMenu:)];
    
    self.navigationItem.leftBarButtonItems = @[pItem];
}

- (void)openLeftMenu:(id)sender
{
    NSLog(@"left menu");
    if (self.menuContainerViewController.menuState == MFSideMenuStateClosed)
    {
        [self.menuContainerViewController setMenuState:MFSideMenuStateLeftMenuOpen completion:nil];
    }
    else
    {
         [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:nil];
    }
}

@end
