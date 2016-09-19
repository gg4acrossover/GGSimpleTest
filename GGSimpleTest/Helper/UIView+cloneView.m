//
//  UIView+cloneView.m
//  GGSimpleTest
//
//  Created by VietHQ on 9/13/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import "UIView+cloneView.h"

@implementation UIView (cloneView)

- (UIImage*)snapShotImg
{
    UIGraphicsBeginImageContextWithOptions( self.frame.size, YES, 0.0f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:context];
    
    UIImage *snapShot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return snapShot;
}

@end
