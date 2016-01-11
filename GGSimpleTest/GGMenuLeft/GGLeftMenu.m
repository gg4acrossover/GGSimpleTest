//
//  GGLeftMenu.m
//  GGSimpleTest
//
//  Created by viethq on 8/31/15.
//  Copyright (c) 2015 viethq. All rights reserved.
//

#import "GGLeftMenu.h"
#import "MFSideMenu.h"

/**
 * menu list
**/
#import "GGDrawView.h"
#import "GGMenuView.h"
#import "GGAnimView.h"
#import "GGHeaderViewController.h"

/**
 * menu model
**/
#import "GGParseLeftMenu.h"

static NSString *const LEFT_MN_IDENTIFIER = @"LEFT_MN_IDENTIFIER";
static CGFloat const HEADER_TBL_H = 40.0f;

@interface GGLeftMenu ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UITableView *mTblMenu;
@property(nonatomic,strong) NSDictionary *mTblTree;
@property(nonatomic,strong) GGParseLeftMenu *mMenuModel;

@end

@implementation GGLeftMenu

#pragma mark - init
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.mMenuModel = [[GGParseLeftMenu alloc] init];
    }
    
    return self;
}

#pragma mark - view life circle
- (void)viewDidLoad
{
    [super viewDidLoad];

    ////////////// create tableview ////////////
    CGRect s = [UIScreen mainScreen].bounds;
    s.size.height -= 20.0f; // height of status bar
    s.origin.y = 20.0f;
    
    self.mTblMenu = [[UITableView alloc] initWithFrame:s style:UITableViewStylePlain];
    [self.mTblMenu registerClass:[UITableViewCell class]
          forCellReuseIdentifier:LEFT_MN_IDENTIFIER];
    self.mTblMenu.delegate = self;
    self.mTblMenu.dataSource = self;
    [self.view addSubview:self.mTblMenu];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - tbl delegate & datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mMenuModel.mNumberSection;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mMenuModel gg_numberOfRowInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_TBL_H;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *pHeader = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.mTblMenu.frame), HEADER_TBL_H)];
    pHeader.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *pTitleSection = [[UILabel alloc] init];
    pTitleSection.text = [self.mMenuModel gg_titleForSection:section];
    [pTitleSection sizeToFit];
    
    CGRect frameTitle = pTitleSection.frame;
    frameTitle.origin.x = 5.0f;
    frameTitle.origin.y = HEADER_TBL_H*0.5 - CGRectGetHeight(frameTitle)*0.5f;
    pTitleSection.frame = frameTitle;
    [pHeader addSubview:pTitleSection];
    
    return pHeader;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *pCell = [tableView dequeueReusableCellWithIdentifier:LEFT_MN_IDENTIFIER];
    
    pCell.textLabel.text = [self.mMenuModel gg_titleForRow:indexPath.row inSection:indexPath.section];
    
    return pCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class classView = NSClassFromString([self.mMenuModel gg_strClassForRow:indexPath.row
                                                                 inSection:indexPath.section]);
    
    UIViewController *pMenuChooseVC = [[classView alloc] initWithNibName:nil bundle:nil];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController ;
    pMenuChooseVC.title = [self.mMenuModel gg_titleForRow:indexPath.row inSection:indexPath.section];
    navigationController.viewControllers = @[pMenuChooseVC];
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

@end
