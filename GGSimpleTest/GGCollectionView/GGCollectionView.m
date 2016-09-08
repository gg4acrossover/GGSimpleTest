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
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GGCollectionViewCell *pCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier forIndexPath:indexPath];
    
    NSString *pImgName = indexPath.row % 2 ? @"1" : @"2";
    
    pCell.imgView.image = [UIImage imageNamed:pImgName];
    
    return pCell;
}

@end
