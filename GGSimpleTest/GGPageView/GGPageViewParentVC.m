//
//  GGPageViewParentVC.m
//  GGSimpleTest
//
//  Created by VietHQ on 12/28/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import "GGPageViewParentVC.h"
#import "GGPageVC.h"

@interface GGPageViewParentVC ()
<UIPageViewControllerDelegate,
UIPageViewControllerDataSource,
UIScrollViewDelegate>

@property(strong, nonatomic) UIPageViewController *pageViewController;
@property(strong, nonatomic) NSArray<GGPageVC*> *dataSource;
@property(assign, nonatomic) NSUInteger currentIdx;
@property(assign, nonatomic) NSUInteger nextIdx;

@end

@implementation GGPageViewParentVC

#pragma mark - Init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        self.currentIdx = 0;
    }
    
    return self;
}

#pragma mark - View life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[self createPageItems] copy];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    [self.pageViewController setViewControllers:@[self.dataSource[self.currentIdx]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
    [self addChildViewController:self.pageViewController];
    
    UIView *pView = self.pageViewController.view;
    [self.view addSubview:pView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pView)]];
    
    [self.pageViewController didMoveToParentViewController:self];
    
    self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    for (UIView *pView in self.pageViewController.view.subviews)
    {
        if ( [pView isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *pScrollInPageView = (UIScrollView*)pView;
            pScrollInPageView.delegate = self;
            break;
        }
    }
    
    [pView setNeedsLayout];
    [pView layoutIfNeeded];
}

#pragma mark - Common
- (NSArray<GGPageVC*>*)createPageItems
{
    NSMutableArray *pArrVC = [NSMutableArray array];
    for (NSUInteger i = 0; i < 5; ++i)
    {
        GGPageVC *pVC = [[GGPageVC alloc] initWithNibName:nil bundle:nil];
        pVC.idx = i;
        [pArrVC addObject:pVC];
    }
    
    return pArrVC;
}

- (NSArray<GGPageVC*>*)pageContentForCurrentPageNumber
{
    NSMutableArray<GGPageVC*> *pArrVC = [NSMutableArray array];
    for ( NSInteger i = 0; i <= self.currentIdx; ++i)
    {
        [pArrVC addObject:self.dataSource[i]];
    }

    return pArrVC;
}

#pragma mark - Public method
- (void)goToPageAtIdx:(NSUInteger)idx
{
    if (idx >= self.dataSource.count)
    {
        return;
    }
    
    self.currentIdx = idx;
    
    [self.pageViewController setViewControllers:@[self.dataSource[self.currentIdx]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(pageViewParentVC:didGoToPageAtIdx:)])
    {
        [self.delegate pageViewParentVC:self didGoToPageAtIdx:self.currentIdx];
    }
}

#pragma mark - PageView
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger idx = ((GGPageVC*)viewController).idx;
    
    if ( idx <= 0)
    {
        return nil;
    }
    
    --idx;
    
    return self.dataSource[idx];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger idx = ((GGPageVC*)viewController).idx;
    
    if ( idx >= self.dataSource.count - 1)
    {
        return nil;
    }
    
    ++idx;
    
    return self.dataSource[idx];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        NSUInteger index = [self.dataSource indexOfObject: [pageViewController.viewControllers lastObject]];
        
        //NSLog(@"complete idx %li", (long)index);
        
        self.currentIdx = index;
        
        if ([self.delegate respondsToSelector:@selector(pageViewParentVC:didGoToPageAtIdx:)])
        {
            [self.delegate pageViewParentVC:self didGoToPageAtIdx:self.currentIdx];
        }
    }
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"offset %@", NSStringFromCGPoint(scrollView.contentOffset));
    if ( [self.delegate respondsToSelector:@selector(pageViewParentVC:currentContentOffset:)])
    {
        [self.delegate pageViewParentVC:self
                   currentContentOffset:scrollView.contentOffset];
    }
}

@end
