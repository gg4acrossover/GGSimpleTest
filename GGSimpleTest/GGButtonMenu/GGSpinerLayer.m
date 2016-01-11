//
//  GGSpinerLayer.m
//  GGSimpleTest
//
//  Created by viethq on 9/29/15.
//  Copyright © 2015 viethq. All rights reserved.
//

#import "GGSpinerLayer.h"

@implementation GGSpinerLayer

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    
    if (self)
    {
        CGFloat radius = CGRectGetHeight(frame)*0.5f*0.5f;
        self.frame = CGRectMake(0.0f,0.0f,CGRectGetHeight(frame),CGRectGetHeight(frame));
        CGPoint center = CGPointMake( CGRectGetHeight(frame)*0.5f, CGRectGetMidY(self.bounds));
        CGFloat startAngle = -M_PI_2;
        CGFloat endAngle = M_PI_2;
        self.path = [UIBezierPath bezierPathWithArcCenter: center
                                                   radius: radius
                                               startAngle: startAngle
                                                 endAngle: endAngle
                                                clockwise: TRUE].CGPath;
        self.strokeColor = [UIColor whiteColor].CGColor;
        self.fillColor = [UIColor clearColor].CGColor;
        self.lineWidth = 1;
        self.hidden = FALSE;
    }
    
    return self;
}

-(void)animation
{
    self.hidden = FALSE;
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.fromValue = 0;
    rotate.toValue = @(M_PI * 2);
    rotate.duration = 0.4;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotate.repeatCount = HUGE;
    rotate.fillMode = kCAFillModeForwards;
    rotate.removedOnCompletion = false;
    [self addAnimation:rotate forKey:rotate.keyPath];
}

-(void)stopAnimation
{
    self.hidden = true;
    [self removeAllAnimations];
}

@end
