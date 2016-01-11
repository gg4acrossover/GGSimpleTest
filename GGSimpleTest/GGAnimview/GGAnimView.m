//
//  GGAnimView.m
//  GGSimpleTest
//
//  Created by viethq on 8/31/15.
//  Copyright (c) 2015 viethq. All rights reserved.
//

#import "GGAnimView.h"
#import "GGAnimStransition.h"
#import "GGDrawView.h"

static NSInteger const LBL_CLICKME_TAG = 100;

@interface GGAnimView ()

@property(nonatomic, strong) GGAnimStransition *mAnimStransition;

@end

@implementation GGAnimView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    CGRect s = [UIScreen mainScreen].bounds;
    self.view.frame = s;
    
    UILabel *pLbl = [[UILabel alloc] initWithFrame:(CGRect){0.0f, 0.0f, 300.0f, 50.0f}];
    pLbl.text = @"Click Me";
    pLbl.font = [UIFont systemFontOfSize:20];
    pLbl.textColor = [UIColor whiteColor];
    pLbl.textAlignment = NSTextAlignmentCenter;
    [pLbl setCenter:CGPointMake(CGRectGetMidX(s), CGRectGetMidY(s))];
    [self.view addSubview:pLbl];
    pLbl.tag = LBL_CLICKME_TAG;
    
    UITapGestureRecognizer *pTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gg_clickMeCallback:)];
    [pLbl addGestureRecognizer:pTap];
    pLbl.userInteractionEnabled = TRUE;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)gg_clickMeCallback:(UITapGestureRecognizer*)tapGes
{
    //NSLog(@"tap ges");
    self.mAnimStransition = [[GGAnimStransition alloc] init];
    self.mAnimStransition.mTransitionDuration = 0.6f;
    
    GGDrawView *pDrawVC = [[GGDrawView alloc] initWithNibName:nil bundle:nil];
    self.navigationController.delegate = self.mAnimStransition;
    [self.navigationController pushViewController:pDrawVC animated:TRUE];
    self.navigationController.delegate = nil;
}

@end
