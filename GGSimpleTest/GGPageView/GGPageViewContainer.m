//
//  GGPageViewContainer.m
//  GGSimpleTest
//
//  Created by VietHQ on 12/26/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import "GGPageViewContainer.h"
#import "GGSelectionMenuViewController.h"
#import "GGPageViewParentVC.h"
#import "UIViewController+MenuBar.h"

@interface GGPageViewContainer ()<GGSelectionMenuViewControllerDelegate, GGPageViewParentVCDelegate>

@property (strong, nonatomic) NSArray<NSString*> *titleMenu;

@property (weak, nonatomic) IBOutlet UIView *containerSelectionMenuView;

@property (strong, nonatomic) GGSelectionMenuViewController *selectionMenu;

@property (weak, nonatomic) IBOutlet UIView *pageContainerView;

@property (strong, nonatomic) GGPageViewParentVC *pageParentVC;

@end

@implementation GGPageViewContainer

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addHumbergerMenuLeftPosition];
    
    //1. create titleMenu first
    self.titleMenu = @[@"Today Power Deal", @"Hot Power Deal", @"Trending Now", @"Top Buyer", @"Top Seller"];
    
    //2. add menu
    [self addMenuList];
    
    //3. add page
    [self addPages];
    
    //4. goto page
    [self.selectionMenu selectedItemAtIdx:2];
}

- (void)addMenuList
{
    self.selectionMenu = [[GGSelectionMenuViewController alloc] initWithNibName:nil bundle:nil];
    
    [self addChildViewController:self.selectionMenu];
    
    UIView *pView = self.selectionMenu.view;
    [self.containerSelectionMenuView addSubview:pView];
    
    [self.containerSelectionMenuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pView)]];
    
    [self.containerSelectionMenuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pView)]];
    
    [self.selectionMenu didMoveToParentViewController:self];
    
    self.selectionMenu.delegate = self;
    self.selectionMenu.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view setNeedsLayout];
    [self.view layoutSubviews];
    
    [self.selectionMenu setSelectionTitle:self.titleMenu];
}

- (void)addPages
{
    self.pageParentVC = [[GGPageViewParentVC alloc] initWithNibName:nil bundle:nil];
    
    [self addChildViewController:self.pageParentVC];
    
    UIView *pView = self.pageParentVC.view;
    [self.pageContainerView addSubview:pView];
    
    [self.pageContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pView)]];
    
    [self.pageContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pView)]];
    
    [self.pageParentVC didMoveToParentViewController:self];
    
    self.pageParentVC.delegate = self;
    self.pageParentVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view setNeedsLayout];
    [self.view layoutSubviews];
    
    self.pageContainerView.backgroundColor = [UIColor redColor];
}

#pragma mark - GGSelectionMenuViewController delegate
- (void)selectionMenuViewController:(GGSelectionMenuViewController*)vc
               didSelectedItemAtIdx:(NSInteger)idx
{
    if (idx != self.pageParentVC.currentIdx)
    {
        [self.pageParentVC goToPageAtIdx:idx];
    }
}

#pragma mark - GGPageViewParentVC delegate
- (void)pageViewParentVC:(GGPageViewParentVC *)vc didGoToPageAtIdx:(NSUInteger)idx
{
    if (idx != self.selectionMenu.currentIdx)
    {
        [self.selectionMenu selectedItemAtIdx:idx];
    }
}

- (void)pageViewParentVC:(GGPageViewParentVC *)vc currentContentOffset:(CGPoint)offset
{
    
}

@end
