//
//  UIScrollView+GGHeaderView.m
//  GGSimpleTest
//
//  Created by viethq on 12/23/15.
//  Copyright © 2015 viethq. All rights reserved.
//

#import "UIScrollView+GGHeaderView.h"
#import <objc/runtime.h>

// -------------------- INTERFACE --------------------- //
#pragma mark - Interface
@interface GGHeaderView ()

@property (nonatomic, readwrite) GGHeaderViewState state;

@property(nonatomic, assign) BOOL mIsObserving;

@end



// -------------------- SCROLL VIEW --------------------- //
#pragma mark - UIScrollView HeaderView
static void *kUIScrollViewHeaderView;

@implementation UIScrollView (GGHeaderView)

#pragma mark - Public method
- (void)gg_addHeaderView:(UIView*)view andHeight:(CGFloat)h
{
    if(self.mHeaderView)
    {
        [self.mHeaderView.mCustomView removeFromSuperview];
        [self.mHeaderView setMCustomView:view];
    }
    else
    {
        GGHeaderView *pHeaderView = [[GGHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, h) customView: view andShadow:shadow];
        [pHeaderView setClipsToBounds:YES];
        
        [self addSubview:pHeaderView];

        
        UIEdgeInsets newInset = self.contentInset;
        newInset.top = h;
        self.contentInset = newInset;
        
        self.mHeaderView = pHeaderView;
        self.mShowHeaderView = YES;
    }
}

- (void)gg_addHeaderImage:(UIImage *)img andHeight:(CGFloat)h
{
    if (self.mHeaderView)
    {
        UIImageView *pImgView = [[UIImageView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, CGRectGetWidth(self.bounds), h)];
        pImgView.contentMode = UIViewContentModeScaleAspectFill;
        pImgView.image = img;
        [self.mHeaderView setMCustomView:pImgView];
    }
    else
    {
        // add image
        UIImageView *pImgView = [[UIImageView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, CGRectGetWidth(self.bounds), h)];
        pImgView.contentMode = UIViewContentModeScaleAspectFill;
        pImgView.image = img;
        
        GGHeaderView *pHeaderView =[[GGHeaderView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, CGRectGetWidth(self.bounds), h) customView:pImgView andShadow:YES];
        [pHeaderView setClipsToBounds:YES];
        
        [self addSubview:pHeaderView];
        
        UIEdgeInsets newInset = self.contentInset;
        newInset.top = h;
        self.contentInset = newInset;
        
        self.mHeaderView = pHeaderView;
        self.mShowHeaderView = YES;

    }
}

- (void)gg_removeObserver
{
    [self removeObserver:self.mHeaderView forKeyPath:@"contentOffset"];
    [self removeObserver:self.mHeaderView forKeyPath:@"frame"];
}

#pragma mark - Get & Set
- (void)setMHeaderView:(GGHeaderView *)mHeaderView
{
    objc_setAssociatedObject( self,
                              &kUIScrollViewHeaderView,
                              mHeaderView,
                              OBJC_ASSOCIATION_ASSIGN );
}

- (GGHeaderView*)mHeaderView
{
    return objc_getAssociatedObject(self, &kUIScrollViewHeaderView);
}

- (void)setMShowHeaderView:(BOOL)mShowHeaderView
{
    self.mHeaderView.hidden = !mShowHeaderView;
    
    if(!mShowHeaderView)
    {
        if (self.mHeaderView.mIsObserving)
        {
            [self removeObserver:self.mHeaderView forKeyPath:@"contentOffset"];
            [self removeObserver:self.mHeaderView forKeyPath:@"frame"];
            
            self.mHeaderView.mIsObserving = NO;
        }
    }
    else
    {
        if (!self.mHeaderView.mIsObserving)
        {
            [self addObserver: self.mHeaderView
                   forKeyPath: @"contentOffset"
                      options: NSKeyValueObservingOptionNew
                      context: nil];
            
            [self addObserver: self.mHeaderView
                   forKeyPath: @"frame"
                      options: NSKeyValueObservingOptionNew
                      context: nil];
            
            self.mHeaderView.mIsObserving = YES;
        }
    }
}

- (BOOL)mShowHeaderView
{
    return !self.mHeaderView.hidden;
}

@end


// -------------------- HEADER --------------------- //
#pragma mark - GGHeaderView
@implementation GGHeaderView

- (instancetype)initWithFrame: (CGRect)frame
                   customView: (UIView*)customView
                    andShadow: (BOOL)shadow
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        self.mCustomView = customView;
        
        if (shadow)
        {
            self.mShadowView = [[GGShadowView alloc] init];
            [self addSubview:self.mShadowView];
            [self.mShadowView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[mShadowView(8.0)]|" options:NSLayoutFormatAlignAllBottom metrics:nil views:@{@"mShadowView" : self.mShadowView}]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mShadowView]|" options:0 metrics:nil views:@{@"mShadowView" : self.mShadowView}]];
        }
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.mShadowView)
    {
        [self bringSubviewToFront:self.mShadowView];
    }
}

- (void)setMCustomView:(UIView *)mCustomView
{
    if (self->_mCustomView)
    {
        [self->_mCustomView removeFromSuperview];
        self->_mCustomView = nil;
    }
    
    self->_mCustomView = mCustomView;
    [self addSubview:self->_mCustomView];
    
    [self->_mCustomView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|" options:0 metrics:nil views:@{@"customView" : mCustomView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|" options:0 metrics:nil views:@{@"customView" : mCustomView}]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
    else if([keyPath isEqualToString:@"frame"])
    {
        [self layoutSubviews];
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset
{
    // We do not want to track when the parallax view is hidden
    if (contentOffset.y > 0)
    {
        [self setState:GGHeaderViewStateInActive];
    }
    else
    {
        [self setState:GGHeaderViewStateActive];
    }
    
    if(self.state == GGHeaderViewStateActive)
    {
        CGFloat yOffset = contentOffset.y*-1;
        if ([self.mDelegate respondsToSelector:@selector(headerView:willChangeFrame:)])
        {
            [self.mDelegate headerView:self willChangeFrame:self.frame];
        }
        
        [self setFrame:CGRectMake(0, contentOffset.y, CGRectGetWidth(self.frame), yOffset)];
        NSLog(@"%@", NSStringFromCGRect(self.frame));
        
        
        if ([self.mDelegate respondsToSelector:@selector(headerView:didChangeFrame:)])
        {
            [self.mDelegate headerView:self didChangeFrame:self.frame];
        }
    }
}

@end


// -------------------- SHADOW --------------------- //
#pragma mark - GGShadowView
@implementation GGShadowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Gradient Declarations
    NSArray* gradient3Colors = [NSArray arrayWithObjects:
                                (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor,
                                (id)[UIColor clearColor].CGColor, nil];
    CGFloat gradient3Locations[] = {0, 1};
    CGGradientRef gradient3 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient3Colors, gradient3Locations);
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, CGRectGetWidth(rect), 8)];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient3, CGPointMake(0, CGRectGetHeight(rect)), CGPointMake(0, 0), 0);
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(gradient3);
    CGColorSpaceRelease(colorSpace);
    
}

@end


