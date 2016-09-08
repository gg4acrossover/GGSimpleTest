//
//  GGCollectionViewFlowLayout.m
//  GGSimpleTest
//
//  Created by VietHQ on 9/7/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import "GGCollectionViewFlowLayout.h"

static NSInteger const kColumn = 2;

@interface GGCollectionViewFlowLayout()

@property (nonatomic, strong) NSArray<UICollectionViewLayoutAttributes*> *layoutAttributesArray;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation GGCollectionViewFlowLayout

#pragma mark - Require
- (void)prepareLayout
{
    [super prepareLayout];
    
    [self computeAttributesWithItemWidth:[self getItemWidth]];
}

- (NSArray<UICollectionViewLayoutAttributes*>*)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.layoutAttributesArray;
}

#pragma mark - Helper method
- (CGFloat)getContentWidth
{
    CGFloat insetLR = self.sectionInset.left + self.sectionInset.right;
    return self.collectionView.bounds.size.width - insetLR;
}

- (CGFloat)getItemWidth
{
    return [self getContentWidth] / kColumn;
}

- (void)computeAttributesWithItemWidth:(CGFloat)w
{
    CGFloat arrOffsetX[kColumn] = {0};
    
    CGFloat arrOffsetY[kColumn] = {0};
    
    for ( NSInteger i = 0; i < kColumn; ++i)
    {
        arrOffsetX[i] = ([self getItemWidth] + self.minimumInteritemSpacing)*i + self.sectionInset.left;
    }
    
    NSMutableArray<UICollectionViewLayoutAttributes*> *pTempAtt = [NSMutableArray new];
    
    for ( NSInteger section = 0; section < self.collectionView.numberOfSections; ++section)
    {
        for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:section]; ++row)
        {
            NSIndexPath *pIdxPath = [NSIndexPath indexPathForRow:row
                                                       inSection:section];
            
            UICollectionViewLayoutAttributes *pAtt = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:pIdxPath];
            
            // calculate frame of cell
            NSInteger idxColumn = [self getShortestColumn:arrOffsetY];
            
            CGFloat originX = arrOffsetX[idxColumn];
    
            CGFloat originY = arrOffsetY[idxColumn];
            
            CGFloat h = (idxColumn % 2) ? 226.0f : 200.0f;
            
            pAtt.frame = CGRectMake(originX, originY, [self getItemWidth], h);
            
            [pTempAtt addObject:pAtt];
            
            self.contentHeight = MAX(self.contentHeight, CGRectGetMaxY(pAtt.frame));
            
            // update offsetY at current column
            arrOffsetY[idxColumn] += h + self.minimumLineSpacing;
        }
    }
    
    self.layoutAttributesArray = [pTempAtt copy];
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake([self getContentWidth], self.contentHeight + self.minimumLineSpacing);
}

- (CGFloat)getShortestColumn:(CGFloat*)arrOffsetY
{
    NSInteger minIdx = 0;
    NSInteger min = CGFLOAT_MAX;
    
    for ( NSInteger i = 0; i < kColumn; ++i)
    {
        if (arrOffsetY[i] < min)
        {
            min = arrOffsetY[i];
            minIdx = i;
        }
    }
    
    return minIdx;
}

@end
