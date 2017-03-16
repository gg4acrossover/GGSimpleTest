//
//  GGDrawView.m
//  GGSimpleTest
//
//  Created by viethq on 8/31/15.
//  Copyright (c) 2015 viethq. All rights reserved.
//

#import "GGDrawView.h"
#import "GGCircleView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+MenuBar.h"

@interface GGDrawView ()

@end

@implementation GGDrawView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addHumbergerMenuLeftPosition];
    
    if (!self.title)
    {
        self.title = @"Draw";
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor grayColor];
    
    /*
     * circle 1
     */
    UIView *pCircle1 = ({
        UIView *pView = [[UIView alloc]
                         initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f,44.0f)];
        pView.layer.cornerRadius = CGRectGetWidth(pView.frame)*0.5f;
        pView.backgroundColor = [UIColor whiteColor];
        pView;
    });
    [self.view addSubview:pCircle1];
    
    /*
     * circle 2
     */
    UIView *pCircle2 = ({
        UIView *pView = [[UIView alloc]
                         initWithFrame:CGRectMake(80.0f, 80.0f, 90.0f, 90.0f)];
        pView.backgroundColor = [UIColor redColor];
        CAShapeLayer *pShape = [CAShapeLayer layer];
        CGFloat r = CGRectGetWidth(pView.frame)*0.5f;
        CGPoint center = CGPointMake( r, r); // center is center pos of view
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:r
                                                        startAngle:0
                                                          endAngle:2*M_PI
                                                         clockwise:YES];
        pShape.path = path.CGPath;
        pView.layer.mask = pShape;
        pView;
    });
    [self.view addSubview:pCircle2];
    
    /*
     * triangle
     */
    UIView *pTriangle = ({
        UIView *pView = [[UIView alloc] initWithFrame:CGRectMake(200.0f, 200.0f, 100.0f, 100.0f)];
        
        /* first way
        UIBezierPath *pPath = [UIBezierPath bezierPath];
        [pPath moveToPoint:CGPointMake(50.0f, 0.0f)];
        [pPath addLineToPoint:CGPointMake(0.0f, 100.0f)];
        [pPath addLineToPoint:CGPointMake(100.0f, 100.0f)];
        [pPath closePath];
         pShape.path = pPath;
        */
        // end first way
        
        /* second way */
        CGMutablePathRef pPath = CGPathCreateMutable();
        CGPathMoveToPoint(pPath, nil, 50.0f, 0.0f);
        CGPathAddLineToPoint(pPath, nil, 0.0f, 100.0f);
        CGPathAddLineToPoint(pPath, nil, 100.0f, 100.0f);
        CGPathCloseSubpath(pPath);
        // end second way
        
        // add mask
        CAShapeLayer *pShape = [CAShapeLayer layer];
        pShape.path = pPath;
        pView.layer.mask = pShape;
        
        // add border
        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.frame = pView.bounds;
        shape.path = pPath;
        shape.lineWidth = 2.0f;
        shape.strokeColor = [UIColor whiteColor].CGColor;
        shape.fillColor = [UIColor clearColor].CGColor;
        //[pView.layer insertSublayer:shape atIndex:0];
        pView.backgroundColor = [UIColor brownColor];
        
        CGPathRelease(pPath);
        pView;
    });
    
    [self.view addSubview:pTriangle];
    [self.view setNeedsDisplay];
    
    /*
     * view draw rec
     */
    GGCircleView *pCircleView = [[GGCircleView alloc] initWithFrame:CGRectMake(80.0f, 400.0f, 100.0f, 100.0f)];
    pCircleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pCircleView];
}

@end
