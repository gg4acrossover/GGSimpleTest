//
//  GGAutoLayoutViewController.m
//  GGSimpleTest
//
//  Created by viethq on 12/24/15.
//  Copyright © 2015 viethq. All rights reserved.
//

#import "GGAutoLayoutViewController.h"
#import "UIViewController+MenuBar.h"

@interface GGAutoLayoutViewController ()

@property (weak, nonatomic) IBOutlet UIView *mBlueView;
@property (weak, nonatomic) IBOutlet UIView *mRedView;

@end

@implementation GGAutoLayoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addHumbergerMenuLeftPosition];
}

@end
