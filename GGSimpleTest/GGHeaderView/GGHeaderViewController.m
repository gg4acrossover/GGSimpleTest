//
//  GGHeaderViewController.m
//  GGSimpleTest
//
//  Created by viethq on 12/23/15.
//  Copyright © 2015 viethq. All rights reserved.
//

#import "GGHeaderViewController.h"
#import "UIScrollView+GGHeaderView.h"

static CGFloat kHeightHeader = 145.0f;

@interface GGHeaderViewController () <UITableViewDelegate, UITableViewDataSource>

@property( strong, nonatomic) UITableView *mTblView;

@end

@implementation GGHeaderViewController

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mTblView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                 style:UITableViewStylePlain];
    [self.view addSubview:self.mTblView];
    self.mTblView.delegate = self;
    self.mTblView.dataSource = self;
        
    UIImage *pImg = [UIImage imageNamed:@"ParallaxImage.jpg"];
    [self.mTblView gg_addHeaderImage: pImg andHeight:kHeightHeader];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *pIdentifier = @"tblIdentifier";
    UITableViewCell *pCell = [tableView dequeueReusableCellWithIdentifier:pIdentifier];
    
    if (!pCell)
    {
        pCell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier: pIdentifier];
    }
    
    pCell.textLabel.text = [NSString stringWithFormat:@"row %li", (long)indexPath.row];
    pCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return pCell;
}

- (void)dealloc
{
    [self.mTblView gg_removeObserver];
}

@end
