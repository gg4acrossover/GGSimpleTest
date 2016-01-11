//
//  GGCircleView.m
//  GGSimpleTest
//
//  Created by viethq on 9/14/15.
//  Copyright (c) 2015 viethq. All rights reserved.
//

#import "GGCircleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GGCircleView


- (void)drawRect:(CGRect)rect
{
    /*
     * draw by c function, draw a ellipse
     */
//    CGFloat borderWidth = 2.0f;
//    CGRect content = rect;
//    rect.size.width = rect.size.width - borderWidth*0.5f;
//    rect.size.height = rect.size.height - borderWidth*0.5f;
//    CGRect borderRect = CGRectInset( content, borderWidth*0.5f, borderWidth*0.5f);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextAddEllipseInRect(context, borderRect);
//    CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextSetLineWidth(context,borderWidth);
//    CGContextDrawPath(context, kCGPathFillStroke);
    
    /*
     * using bezierpath
     */
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGPoint center = CGPointMake(rect.size.width*0.5f, rect.size.height*0.5f);
//    UIBezierPath *pPath = [UIBezierPath bezierPathWithArcCenter: center
//                                                         radius: rect.size.width*0.5f
//                                                     startAngle: 0
//                                                       endAngle: M_PI_2 + M_PI
//                                                      clockwise: FALSE];
//    [pPath addLineToPoint:center];
//    CGContextAddPath(context, pPath.CGPath);
//    CGContextClosePath(context);
//    CGContextDrawPath(context, kCGPathStroke);
    
    /*
     *
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(rect.size.width*0.5f, rect.size.height*0.5f);
    UIBezierPath *pPath = [UIBezierPath bezierPath];
    [pPath moveToPoint:center];
    [pPath addCurveToPoint:CGPointMake(center.x, rect.size.height-1.0f)
             controlPoint1:CGPointMake(rect.size.width, 0.0f)
             controlPoint2:CGPointMake(rect.size.width, rect.size.width)];
    [pPath moveToPoint:center];
    [pPath addCurveToPoint:CGPointMake(center.x, rect.size.height-1.0f)
             controlPoint1:CGPointZero
             controlPoint2:CGPointMake(0.0f, rect.size.width)];
    CGContextAddPath(context, pPath.CGPath);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
