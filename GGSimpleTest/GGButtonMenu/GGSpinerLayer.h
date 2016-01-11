//
//  GGSpinerLayer.h
//  GGSimpleTest
//
//  Created by viethq on 9/29/15.
//  Copyright © 2015 viethq. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface GGSpinerLayer : CAShapeLayer

-(instancetype)initWithFrame:(CGRect)frame;
-(void)animation;
-(void)stopAnimation;

@end
