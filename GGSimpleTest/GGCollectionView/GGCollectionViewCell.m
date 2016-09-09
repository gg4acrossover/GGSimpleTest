//
//  GGCollectionViewCell.m
//  GGSimpleTest
//
//  Created by VietHQ on 9/7/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import "GGCollectionViewCell.h"

@implementation GGCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.imgView.backgroundColor = [UIColor lightGrayColor];
    [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
}

@end
