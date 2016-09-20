//
//  GGPageViewVC.m
//  GGSimpleTest
//
//  Created by VietHQ on 9/12/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import "GGPageViewVC.h"
#import "GGAnimationTransitionVC.h"
#import <UIImageView+WebCache.h>
#import "GGAnimationTransitionVC.h"

static NSString *const kIdentifier = @"kIdentifier";
static NSInteger const kTagImage = 200;

@interface GGPageViewVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GGPresentedVCDelegate>

@end

@implementation GGPageViewVC

#pragma mark - View life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UICollectionViewFlowLayout *pLayout = [[UICollectionViewFlowLayout alloc]  init];
    pLayout.minimumLineSpacing = 0.0f;
    pLayout.minimumInteritemSpacing = 0.0f;
    pLayout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    pLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.collectionViewLayout = pLayout;
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:kIdentifier];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.currentIdxPath)
    {
        [self.collectionView setContentOffset:CGPointMake( [UIScreen mainScreen].bounds.size.width*self.currentIdxPath.row, 0.0f) animated:NO];
        
        [self.collectionView setNeedsLayout];
        [self.collectionView layoutIfNeeded];
        
        [self.collectionView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - Get & set
- (void)setUrlImage:(NSArray<NSString *> *)urlImage
{
    self->_urlImage = urlImage;
    
    [self.collectionView reloadData];
}

- (CGSize)getCellSize
{
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
}

- (CGRect)getFrameImageOfCell:(UICollectionViewCell*)cell
{
    CGRect rec = CGRectMake( 10.0f, 10.0f, CGRectGetWidth(self.collectionView.frame) - 20.0f,
                             CGRectGetHeight(self.collectionView.frame) - 20.0f );
    
    return rec;
}

- (UIImageView*)createImageForCellAtIdxPath:(NSIndexPath*)idxPath
{
    UICollectionViewCell *pCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier forIndexPath:idxPath];
    
    UIImageView *pImgView = ({
        UIImageView *pImg = [[UIImageView alloc] initWithFrame:[self getFrameImageOfCell:pCell]];
        
        pImg.backgroundColor = [UIColor whiteColor];
        pImg.contentMode = UIViewContentModeScaleAspectFit;
        [pImg sd_setImageWithURL: [NSURL URLWithString:self.urlImage[idxPath.row]]];
        pImg.tag = kTagImage;
        
        pImg;
    });
    
    return pImgView;
}

- (void)removeImageForCell:(UICollectionViewCell*)cell
{
    UIView *pImageContainer = [cell viewWithTag:kTagImage];
    [pImageContainer removeFromSuperview];
}

#pragma mark - CollectionView delegate & datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.urlImage.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellSize];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *pCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier
                                                                                 forIndexPath:indexPath];
    
    // cell config
    [self removeImageForCell:pCell];
    
    [pCell addSubview:[self createImageForCellAtIdxPath:indexPath]];
    
    // update for vc
    self.title = [NSString stringWithFormat:@"[%li - %li]", (long)indexPath.section, (long)indexPath.row];
    
    // update idx path
    if ([[self.collectionView indexPathsForVisibleItems] containsObject:self.currentIdxPath])
    {
        self.currentIdxPath = indexPath;
        self.transitionManager.destinationIdxPath = self.currentIdxPath;
        self.transitionManager.InitIdxPath = self.currentIdxPath;

    }
    
    return pCell;
}

#pragma mark - Presented delegate
- (CGRect)destinationFrame:(NSIndexPath*)idxPath isPresenting:(BOOL)isPresenting
{
    UICollectionViewCell *pCell = [self.collectionView cellForItemAtIndexPath:idxPath];
    
    return [self getFrameImageOfCell:pCell];
}

- (UIView*)destinationView:(NSIndexPath*)idxPath isPresenting:(BOOL)isPresenting
{
    UICollectionViewCell *pCell = [self.collectionView cellForItemAtIndexPath:idxPath];
    
    return [pCell viewWithTag:kTagImage];
}

- (void)prepareDestinationViewAppear:(NSIndexPath*)idxPath isPresenting:(BOOL)isPresenting
{
    if (self.currentIdxPath && isPresenting)
    {
        [self.collectionView setContentOffset:CGPointMake( [UIScreen mainScreen].bounds.size.width*self.currentIdxPath.row, 0.0f) animated:NO];
        
        
        [self.collectionView reloadData];
        
        [self.collectionView setNeedsLayout];
        [self.collectionView layoutIfNeeded];
    }
}

@end
