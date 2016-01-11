//
//  GGAnimStransition.h
//  GGSimpleTest
//
//  Created by viethq on 9/1/15.
//  Copyright (c) 2015 viethq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGAnimStransition.h"

@interface GGAnimStransition : NSObject<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) NSTimeInterval mTransitionDuration;

@end
