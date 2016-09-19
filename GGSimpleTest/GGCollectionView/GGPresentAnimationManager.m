//
//  GGPresentAnimationManager.m
//  GGSimpleTest
//
//  Created by VietHQ on 9/13/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import "GGPresentAnimationManager.h"
#import "GGAnimationTransitionVC.h"
#import <MFSideMenu.h>
#import "UIView+cloneView.h"

@implementation GGPresentAnimationManager

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.7f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    /////////// FROM VC    
    UIViewController<GGPresentingVCDelegate> *pRootVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect initFrame = [pRootVC initialFrame:self.animManager.InitIdxPath isPresenting:YES];
    
    ////////// TO VC
    UIViewController<GGPresentedVCDelegate> *pToVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect ToViewFinalRect = [transitionContext finalFrameForViewController:pToVC];
    pToVC.view.frame = ToViewFinalRect;
    pToVC.view.alpha = 0.f;
    [pToVC prepareDestinationViewAppear:self.animManager.destinationIdxPath isPresenting:YES];
    
    NSIndexPath *pIdx = self.animManager.destinationIdxPath;
    CGRect destinationFrame = [pToVC destinationFrame:pIdx isPresenting:YES];
    destinationFrame.origin.y += 64.0f;
    
    UIView *pCellDes = [pToVC destinationView:pIdx isPresenting:YES];
    
    UIImage *pDesImg = [pCellDes snapShotImg];
    pCellDes.hidden = YES;
    
    UIImageView *pImageDes = [[UIImageView alloc] initWithImage:pDesImg];
    pImageDes.frame = initFrame;
    pImageDes.contentMode = UIViewContentModeScaleAspectFit;
    pImageDes.alpha = 0.0f;
    
    
    ////////// FREPARE
    UIView *pContainer = [transitionContext containerView];
    [pContainer addSubview:pToVC.view];
    [pContainer addSubview:pImageDes];
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        pImageDes.alpha = 1.0f;
        pImageDes.frame = destinationFrame;
        
        pToVC.view.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        [pImageDes removeFromSuperview];
        pCellDes.hidden = NO;
    
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
