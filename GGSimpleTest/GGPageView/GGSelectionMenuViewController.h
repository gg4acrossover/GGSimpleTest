//
//  GGSelectionMenuViewController.h
//  GGSimpleTest
//
//  Created by VietHQ on 12/27/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGSelectionMenuViewController;

@protocol GGSelectionMenuViewControllerDelegate <NSObject>

-(void)selectionMenuViewController:( GGSelectionMenuViewController* _Nonnull )vc
                didSelectedItemAtIdx:(NSInteger)idx;

@end

@interface GGSelectionMenuViewController : UIViewController

@property (assign, nonatomic, readonly) NSInteger currentIdx;

@property (weak, nonatomic, nullable) id<GGSelectionMenuViewControllerDelegate> delegate;

- (void)setSelectionTitle:(NSArray<NSString*>* _Nonnull)titles;

- (void)setTextColor:(UIColor* _Nonnull)color;

- (void)setBgColor:(UIColor* _Nonnull)color;

- (void)setBgCellColor:(UIColor* _Nonnull)color;

- (void)selectedItemAtIdx:(NSUInteger)idx;

@end
