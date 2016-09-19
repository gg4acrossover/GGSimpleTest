//
//  GGAnimationTransitionVC.h
//  GGSimpleTest
//
//  Created by VietHQ on 9/13/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGPresentAnimationManager.h"
#import "GGDismissAnimationVC.h"

@protocol GGPresentingVCDelegate  <NSObject>

- (CGRect)initialFrame:(NSIndexPath*)idxPath isPresenting:(BOOL)isPresenting;

- (UIView*)initialView:(NSIndexPath*)idxPath isPresenting:(BOOL)isPresenting;

- (void)prepareViewAppear:(NSIndexPath*)idxPath isPresenting:(BOOL)isPresenting;

@end

@protocol GGPresentedVCDelegate <NSObject>

- (CGRect)destinationFrame:(NSIndexPath*)idxPath isPresenting:(BOOL)isPresenting;

- (UIView*)destinationView:(NSIndexPath*)idxPath isPresenting:(BOOL)isPresenting;

- (void)prepareDestinationViewAppear:(NSIndexPath*)idxPath isPresenting:(BOOL)isPresenting;

@end

@interface GGAnimationTransitionVC : NSObject<UINavigationControllerDelegate>

@property( strong, nonatomic) NSIndexPath *InitIdxPath;
@property( strong, nonatomic) NSIndexPath *destinationIdxPath;

@property( strong, nonatomic) GGPresentAnimationManager *presentAnim;
@property( strong, nonatomic) GGDismissAnimationVC *dismissAnim;

@end
