//
//  GGDismissAnimationVC.h
//  GGSimpleTest
//
//  Created by VietHQ on 9/16/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GGAnimationTransitionVC;

@interface GGDismissAnimationVC : NSObject<UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) GGAnimationTransitionVC *animManager;

@end
