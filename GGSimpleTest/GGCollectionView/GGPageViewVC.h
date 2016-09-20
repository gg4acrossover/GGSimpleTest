//
//  GGPageViewVC.h
//  GGSimpleTest
//
//  Created by VietHQ on 9/12/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGAnimationTransitionVC;

@interface GGPageViewVC : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray<NSString*> *urlImage;

@property (strong, nonatomic) NSIndexPath *currentIdxPath;

@property (weak, nonatomic) GGAnimationTransitionVC *transitionManager;

@end
