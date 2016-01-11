//
//  UIScrollView+GGHeaderView.h
//  GGSimpleTest
//
//  Created by viethq on 12/23/15.
//  Copyright © 2015 viethq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGHeaderView;
@class GGShadowView;
@protocol GGHeaderViewDelegate;

typedef NS_ENUM( NSInteger, GGHeaderViewState)
{
    GGHeaderViewStateActive,
    GGHeaderViewStateInActive
};

@interface UIScrollView (GGHeaderView)

@property (nonatomic, strong, readonly) GGHeaderView *mHeaderView;
@property (nonatomic, assign) BOOL mShowHeaderView;

- (void)gg_addHeaderView:(UIView*)view andHeight:(CGFloat)h;
- (void)gg_addHeaderImage:(UIImage*)img andHeight:(CGFloat)h;
- (void)gg_removeObserver;

@end

@interface  GGHeaderView : UIView

@property( strong, nonatomic) UIView *mCustomView;
@property( strong, nonatomic) GGShadowView *mShadowView;
@property( weak, nonatomic) id<GGHeaderViewDelegate> mDelegate;

- (instancetype)initWithFrame: (CGRect)frame
                   customView: (UIView*)customView
                    andShadow: (BOOL)shadow;

@end

@protocol GGHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(GGHeaderView *)view willChangeFrame:(CGRect)frame;
- (void)headerView:(GGHeaderView *)view didChangeFrame:(CGRect)frame;

@end

@interface GGShadowView : UIView

@end
