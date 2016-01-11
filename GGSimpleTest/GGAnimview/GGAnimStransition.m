//
//  GGAnimStransition.m
//  GGSimpleTest
//
//  Created by viethq on 9/1/15.
//  Copyright (c) 2015 viethq. All rights reserved.
//

#import "GGAnimStransition.h"
#import "GGBasicAnimation.h"

@interface GGAnimStransition()

@property (nonatomic, assign) BOOL mIsDismiss;
@property (nonatomic, assign) BOOL mIsNavigationTransition;

@end

@implementation GGAnimStransition

-(NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return self.mTransitionDuration ? : 0.33f;
}

-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.mIsDismiss)
    {
        [self gg_dismissWithTransition:transitionContext];
    }
    else
    {
        [self gg_presentVCWithTransition:transitionContext];
    }
}

-(void)gg_dismissWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    
    UIView *containerView = [transitionContext containerView];
    
    if (self.mIsNavigationTransition)
    {
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
    }
    
    CGRect fromRect = [transitionContext finalFrameForViewController:toViewController];
    CGRect startRect = fromRect;
    startRect.origin.x = -CGRectGetWidth(startRect);
    
    [UIView animateWithDuration:self.mTransitionDuration
                     animations:^{
                         fromView.frame = startRect;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];

}

-(void)gg_presentVCWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *pToVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *pToView = pToVC.view;
    UIView *pContainerView = [transitionContext containerView];
    [pContainerView addSubview:pToView];
    
    CGRect ToViewFinalRect = [transitionContext finalFrameForViewController:pToVC];
    pToView.frame = ToViewFinalRect;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = pToView.bounds;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    pToView.layer.mask = maskLayer;
    
    GGBasicAnimation *animation = [GGBasicAnimation animationWithKeyPath:@"path"];
    animation.removedOnCompletion = YES;
    animation.duration = self.mTransitionDuration;
    
    CGPoint center = CGPointZero;
    CGFloat radius = 0;
    NSLog(@"center toView %f", CGRectGetMidY(ToViewFinalRect));
    center = CGPointMake(CGRectGetMidX(ToViewFinalRect),CGRectGetHeight(ToViewFinalRect)*0.5f - 64.0f);
    radius = sqrt((CGRectGetWidth(ToViewFinalRect) *CGRectGetWidth(ToViewFinalRect)/4 + CGRectGetHeight(ToViewFinalRect)*CGRectGetHeight(ToViewFinalRect))/4);
    
    animation.fromValue = (__bridge id)([UIBezierPath bezierPathWithArcCenter:center radius:1 startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath);
    animation.toValue = (__bridge id)[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
    [maskLayer setValue:animation.toValue forKey:animation.keyPath];
    [maskLayer addAnimation:animation forKey:animation.keyPath];
    
    [animation setCompletion:^(BOOL finished) {
        [pToView.layer.mask removeFromSuperlayer];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];

}

#pragma mark - UINavigationControllerDelegate methods
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                 animationControllerForOperation:(UINavigationControllerOperation)operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *)toVC
{
    NSInteger fromIndex = [navigationController.viewControllers indexOfObject:fromVC];
    NSInteger toIndex = [navigationController.viewControllers indexOfObject:toVC];
    if (fromIndex > toIndex)
    {
        self.mIsDismiss = TRUE;
    }
    else
    {
        self.mIsDismiss = FALSE;
    }
    self.mIsNavigationTransition = TRUE;
    return self;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    return nil;
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

-(void)dealloc
{
    
}

@end
