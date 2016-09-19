//
//  GGAnimationTransitionVC.m
//  GGSimpleTest
//
//  Created by VietHQ on 9/13/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import "GGAnimationTransitionVC.h"

@implementation GGAnimationTransitionVC

#pragma mark - Get & set
- (void)setPresentAnim:(GGPresentAnimationManager *)presentAnim
{
    self->_presentAnim = presentAnim;
    presentAnim.animManager = self;
}

- (void)setDismissAnim:(GGDismissAnimationVC *)dismissAnim
{
    self->_dismissAnim = dismissAnim;
    dismissAnim.animManager = self;
}

#pragma mark - Navigation delegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                 animationControllerForOperation:(UINavigationControllerOperation)operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop)
    {
        return self.dismissAnim;
    }
    
    return self.presentAnim;
}


-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    return nil;
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}


@end
