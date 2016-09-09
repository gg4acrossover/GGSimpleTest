//
//  GGCollectionViewFlowLayout.h
//  GGSimpleTest
//
//  Created by VietHQ on 9/7/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  GGCollectionViewFlowLayoutDelegate<NSObject>

- (CGFloat) collectionView:(UICollectionView*)collectionView
  getHeighForCellAtIdxPath:(NSIndexPath*)idxPath
             withCellWidth:(CGFloat)w;

@end

@interface GGCollectionViewFlowLayout : UICollectionViewFlowLayout

@property( weak, nonatomic) id<GGCollectionViewFlowLayoutDelegate> delegate;

@end
