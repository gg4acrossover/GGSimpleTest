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

static NSString *const kIdentifier = @"GGCollectionViewCell";
static NSString *const kHeaderIdentifier = @"header";

@interface GGCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation GGCollectionView

#pragma mark -  View life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    self.collectionView.collectionViewLayout = pLayOut;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Collection view
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GGCollectionViewCell *pCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier forIndexPath:indexPath];
    
    NSString *pImgName = indexPath.row % 2 ? @"1" : @"2";
    
    pCell.imgView.image = [UIImage imageNamed:pImgName];
    
    return pCell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView
          viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if( [kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *pHeader = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
        
        pHeader.backgroundColor = [UIColor lightGrayColor];
        
        return pHeader;
    }
    
    return nil;
}

@end
