//
//  GGCollectionView.m
//  GGSimpleTest
//
//  Created by VietHQ on 9/6/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import "GGCollectionView.h"
#import "GGCollectionViewCell.h"
#import "GGCollectionViewFlowLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GGPageViewVC.h"
#import "GGAnimationTransitionVC.h"
#import "UIViewController+MenuBar.h"

static NSString *const kIdentifier = @"GGCollectionViewCell";
static NSString *const kHeaderIdentifier = @"header";

@interface GGCollectionView ()
<   UICollectionViewDelegate,
    UICollectionViewDataSource,
    GGCollectionViewFlowLayoutDelegate,
    GGPresentingVCDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray<NSString*> *urlImageList;
@property (strong, nonatomic) GGAnimationTransitionVC *animManager;

@end

@implementation GGCollectionView

#pragma mark - Init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if ( self)
    {
        [self createURLImage];
    }
    
    return self;
}

#pragma mark -  View life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addHumbergerMenuLeftPosition];
    
    [self settingCollectionView];
}

- (void)settingCollectionView
{
    [self.collectionView registerNib:[UINib nibWithNibName:kIdentifier bundle:nil]
          forCellWithReuseIdentifier:kIdentifier];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
    
    GGCollectionViewFlowLayout *pLayOut = [[GGCollectionViewFlowLayout alloc] init];
    pLayOut.minimumLineSpacing = 10.f;
    pLayOut.minimumInteritemSpacing = 10.f;
    pLayOut.delegate = self;
    self.collectionView.collectionViewLayout = pLayOut;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    self.collectionView.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.collectionView.hidden = NO;
    });
}

#pragma mark - Collection view
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.urlImageList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GGCollectionViewCell *pCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier forIndexPath:indexPath];
    
    SDImageCache *pImgCache = [SDImageCache sharedImageCache];
    UIImage *pCurrentImage = [pImgCache imageFromMemoryCacheForKey:self.urlImageList[indexPath.row]];
    
    if (pCurrentImage)
    {
        pCell.imgView.image = pCurrentImage;
    }
    else
    {
        if (!self.collectionView.isDragging)
        {
            [self downloadImageForCellAtIdxPath:indexPath];
        }
    }
    
    pCell.titleLabel.text = [NSString stringWithFormat:@"[%li - %li]", (long)indexPath.row, (long)indexPath.section];
    
    pCell.layer.shouldRasterize = YES;
    pCell.layer.rasterizationScale = [UIScreen mainScreen].scale;

    
    return pCell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView
          viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if( [kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *pHeader = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
        
        pHeader.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5f];
        
        return pHeader;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // prepare animManager
    self.animManager = [[GGAnimationTransitionVC alloc] init];
    
    self.animManager.InitIdxPath = indexPath;
    self.animManager.destinationIdxPath = indexPath;
    
    self.animManager.presentAnim = [[GGPresentAnimationManager alloc] init];
    self.animManager.dismissAnim = [[GGDismissAnimationVC alloc] init];
    
    self.navigationController.delegate = self.animManager;

    // prepare viewcontroller
    GGPageViewVC *pVC = [[GGPageViewVC alloc] initWithNibName:nil bundle:nil];
    
    pVC.currentIdxPath = indexPath;
    pVC.urlImage = self.urlImageList;
    pVC.transitionManager = self.animManager;
    
    // show title "back" in navigation left button for next viewcontroller
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    
    [self.navigationItem setBackBarButtonItem:backItem];
    
    [self.navigationController pushViewController:pVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    SDWebImageManager *pManager = [SDWebImageManager sharedManager];
    [pManager cancelAll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView setAnimationsEnabled:NO];
    
    __weak typeof (self) thiz = self;
    
    [self.collectionView performBatchUpdates:^{
        
        [UIView setAnimationsEnabled:NO];
        
        [thiz.collectionView reloadItemsAtIndexPaths:[thiz.collectionView indexPathsForVisibleItems]];
        
    } completion:^(BOOL finished) {
        [UIView setAnimationsEnabled:YES];
    }];
}

#pragma mark - CollectionView helper
- (void)downloadImageForCellAtIdxPath:(NSIndexPath*)idxPath
{
    NSString *pUrlStr = self.urlImageList[idxPath.row];
    
    SDWebImageManager *pManager = [SDWebImageManager sharedManager];
    [pManager downloadImageWithURL:[NSURL URLWithString:pUrlStr]
                           options:SDWebImageRetryFailed
                          progress:nil
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         if (image && !error)
         {
             //self.cacheImg[idxPath] = image;
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.collectionView reloadItemsAtIndexPaths:@[idxPath]];
             });
         }
     }];
}

#pragma mark - Layout delegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
 getHeighForCellAtIdxPath:(NSIndexPath *)idxPath
            withCellWidth:(CGFloat)w
{
    CGFloat newH = 0.0f;
    
    SDImageCache *pImgCache = [SDImageCache sharedImageCache];
    UIImage *pCurrentImage = [pImgCache imageFromMemoryCacheForKey:self.urlImageList[idxPath.row]];
    
    if (pCurrentImage)
    {
        newH = pCurrentImage.size.height *  w / pCurrentImage.size.width;
    }
    
    // show log height estimate
    //NSLog(@"%f", newH);
    
    // 45.0f is estimate height for view under image
    return newH + 45.0f;
}

#pragma mark - Present animation delegate
- (CGRect)initialFrame:(NSIndexPath *)idxPath isPresenting:(BOOL)isPresenting
{
    // if cell is loaded
    GGCollectionViewCell *pCell = (GGCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:idxPath];
    
    if (pCell)
    {
        return [pCell convertRect:pCell.imgView.frame toView:self.view];
    }
    
    
    UICollectionViewLayoutAttributes *pAtt = [self.collectionView layoutAttributesForItemAtIndexPath:idxPath];
    CGRect imageRec = pAtt.frame;
    imageRec.size.height -= 45.0f;
    
    return [self.collectionView convertRect:imageRec toView:self.view];
}

- (UIView*)initialView:(NSIndexPath *)idxPath isPresenting:(BOOL)isPresenting
{
    UICollectionViewCell *pCell = [self.collectionView cellForItemAtIndexPath:idxPath];
    
    return pCell.contentView;
}

- (void)prepareViewAppear:(NSIndexPath *)idxPath isPresenting:(BOOL)isPresenting
{
    if ( !isPresenting && ![[self.collectionView indexPathsForVisibleItems] containsObject:idxPath])
    {
        __weak typeof (self) thiz = self;
        
        [thiz.collectionView performBatchUpdates:nil completion:nil];
        
        [thiz.collectionView scrollToItemAtIndexPath:idxPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                            animated:NO];
        
        [thiz.collectionView reloadData];
        
        [thiz.collectionView layoutIfNeeded];

    }
}

#pragma mark - Data
- (void)createURLImage
{
    //////// Section 0 //////////
    self.urlImageList = @[
                          @"http://xqproduct.xiangqu.com/FrQbHmZzI-MGDQfQGQxrggRe8TUa?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/700x700/",
                          
                          @"http://xqproduct.xiangqu.com/Fj2kU4K_TS8Kvolme1FhZpmB8weh?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/800x800/",
                          
                          @"http://xqproduct.xiangqu.com/FoYm07fprsGaSbbFYzAUXbAwMH09?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/1800x1200/",
                          
                          @"http://xqproduct.xiangqu.com/FsMd6kTVFnqL5qhupgNeYu4veM39?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/800x800/",
                          
                          @"http://xqproduct.xiangqu.com/Fk8Q5q_MxELt_dFWP8afoGI38kmr?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/750x500/",
                          
                          @"http://xqproduct.xiangqu.com/FnR4RLXJjxLLWk4wvHC4WP5W_M4_?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/800x800/",
                          
                          @"http://xqproduct.xiangqu.com/Fmsvn7L8TJ_m9RFgqyJHT40MZmVE?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/900x900/",
                          
                          @"http://xqproduct.xiangqu.com/FkKSh-s49Lh767u9bDMCIUF4mIDJ?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/2500x1667/",
                          
                          @"http://xqproduct.xiangqu.com/FsWsi3hPBTQnhOAVUIj-mF7WZZWE?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/700x864/",
                          
                          @"http://xqproduct.xiangqu.com/FvpQ0MwpjqZfy2X-jvX4CtpyLtXN?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/780x518/",
                          
                          @"http://xqproduct.xiangqu.com/FgeHAXZGHMPnnXpoVgCdFwXd3w6z?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/1600x1600/",
                          
                          @"http://xqproduct.xiangqu.com/FnV26KwCeWQLKeM0fP_Z2ji8N7jx?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/800x800/",
                          
                          @"http://xqproduct.xiangqu.com/Fuh3sKHDRUaLCHbopi25LpYrxRmr?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/800x800/",
                          
                          @"http://xqproduct.xiangqu.com/FvUxhTJSYBuFloPwHM-OeM399bfV?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/700x1161/",
                          
                          @"http://xqproduct.xiangqu.com/FveDrjGHXJ8kqH9LVqnm8mIc_Ebu?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/600x600/",
                          
                          @"http://xqproduct.xiangqu.com/FjcO7UoUJfLkrk50CPnGnkTVtPnM?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/500x500/",
                          
                          @"http://xqproduct.xiangqu.com/FkyTmgsMLpHVVtRb2swexk4Sog1x?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/640x981/",
                          
                          @"http://xqproduct.xiangqu.com/FiuHw7kOWYitP0m4IoPZzJ3xIcmv?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/600x600/",
                          
                          @"http://xqproduct.xiangqu.com/FvLmc4mXWkadpNRVJsRwlUabwFw1?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/800x800/",
                          
                          @"http://xqproduct.xiangqu.com/Fku8nFowE8o6Q5KgIZ3Oa083riHo?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/460x460/",
                          
                          @"http://xqproduct.xiangqu.com/Fjh9tUJKPi56PDopd5rnGnEd90Um?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/800x800/",
                          
                          @"http://xqproduct.xiangqu.com/FsA0YbOm5fioYJIpyz8rsNoG7RVh?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/700x700/",
                          
                          @"http://xqproduct.xiangqu.com/FnHGHyoDQC0xX8XhSLmB7tPx4lQk?imageView2/2/w/300/q/90/format/jpg/@w/$w$@/@h/$h$@/750x750/"
                          ];
}

@end
