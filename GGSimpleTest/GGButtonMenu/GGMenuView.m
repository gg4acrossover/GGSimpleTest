//
//  GGMenuView.m
//  GGSimpleTest
//
//  Created by viethq on 8/31/15.
//  Copyright (c) 2015 viethq. All rights reserved.
//

#import "GGMenuView.h"
#import "GGBtnAnim.h"

@interface GGMenuView ()

@end

@implementation GGMenuView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    
    GGBtnAnim *pBtnAnim = [[GGBtnAnim alloc] initWithFrame:CGRectMake(20.0f, CGRectGetHeight(self.view.bounds) - (40.0f + 80.0f), [UIScreen mainScreen].bounds.size.width - 40.0f, 40.0f)];
    [self.view addSubview:pBtnAnim];
    [pBtnAnim setTitle:@"Click Here" forState:UIControlStateNormal];
    [pBtnAnim addTarget:self action:@selector(PresentViewController:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)PresentViewController:(UIButton*)btn
{

}

@end
