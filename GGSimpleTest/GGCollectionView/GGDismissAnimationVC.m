//
//  GGDismissAnimationVC.m
//  GGSimpleTest
//
//  Created by VietHQ on 9/16/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import "GGDismissAnimationVC.h"
#import "GGAnimationTransitionVC.h"
#import "UIView+cloneView.h"

@implementation GGDismissAnimationVC

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;
{
    return 0.7f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    ///////// FROM VC
    UIViewController<GGPresentedVCDelegate> *pFromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // get first rec for animation
    [pFromVC prepareDestinationViewAppear:self.animManager.destinationIdxPath isPresenting:NO];
    CGRect initFrame = [pFromVC destinationFrame:self.animManager.destinationIdxPath isPresenting:NO];
    
    // view from vc
    UIImageView *pFromVCCurrentCell = (UIImageView*)[pFromVC destinationView:self.animManager.destinationIdxPath isPresenting:NO];
    
    UIImageView *pImageFrom = [[UIImageView alloc] initWithImage:pFromVCCurrentCell.image];
    pImageFrom.frame = initFrame;
    pImageFrom.contentMode = UIViewContentModeScaleAspectFit;
    
    pFromVCCurrentCell.hidden = YES;
    
    ///////// TO VC
    UIViewController<GGPresentingVCDelegate> *pToVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [pToVC prepareViewAppear:self.animManager.InitIdxPath isPresenting:NO];
    pToVC.view.frame = [transitionContext finalFrameForViewController:pToVC];
    pToVC.view.alpha = 0.0f;
    
    // frame for image when finish transition
    CGRect descriptionFrame = [pToVC initialFrame:self.animManager.InitIdxPath isPresenting:NO];
    
    
    ////////// FREPARE
    UIView *pContainer = [transitionContext containerView];
    [pContainer addSubview:pToVC.view];
    [pContainer addSubview:pImageFrom];
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        pImageFrom.frame = descriptionFrame;
        pToVC.view.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        [pImageFrom removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];

}


@end
