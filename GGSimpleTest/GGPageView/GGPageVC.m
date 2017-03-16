//
//  GGPageVC.m
//  GGSimpleTest
//
//  Created by VietHQ on 12/28/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import "GGPageVC.h"

@interface GGPageVC ()

@property(strong, nonatomic) UILabel *numberLabel;

@end

@implementation GGPageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     * background for page view item
     */
    self.view.backgroundColor = [UIColor blackColor];
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.numberLabel.font = [UIFont systemFontOfSize:14.f];
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.center = self.view.center;
    self.numberLabel.text = [NSString stringWithFormat:@"# %li", self.idx];
    [self.numberLabel sizeToFit];
    
    [self.view addSubview:self.numberLabel];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.numberLabel.center = self.view.center;
}

- (void)setIdx:(NSInteger)idx
{
    self->_idx = idx;
    if (self.numberLabel)
    {
        self.numberLabel.text = [NSString stringWithFormat:@"# %li", self.idx];
    }
}

@end
