//
//  GGPageViewParentVC.h
//  GGSimpleTest
//
//  Created by VietHQ on 12/28/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPageViewParentVC;

@protocol GGPageViewParentVCDelegate <NSObject>

- (void)pageViewParentVC:(GGPageViewParentVC*)vc didGoToPageAtIdx:(NSUInteger)idx;

- (void)pageViewParentVC:(GGPageViewParentVC *)vc currentContentOffset:(CGPoint)offset;

@end

@interface GGPageViewParentVC : UIViewController

@property(assign, nonatomic, readonly) NSUInteger currentIdx;

@property(weak, nonatomic) id<GGPageViewParentVCDelegate> delegate;

- (void)goToPageAtIdx:(NSUInteger)idx;

@end
