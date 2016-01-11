//
//  GGBasicAnimation.h
//  GGSimpleTest
//
//  Created by viethq on 9/3/15.
//  Copyright (c) 2015 viethq. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_INLINE CGFloat CGPointDistance(CGPoint fromPoint,CGPoint toPoint){
    CGFloat distance;
    CGFloat xDist = (toPoint.x - fromPoint.x);
    CGFloat yDist = (toPoint.y - fromPoint.y);
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}

@interface GGBasicAnimation : CABasicAnimation

@property( nonatomic, copy) void(^completion)(BOOL finish);
@property( nonatomic, copy) void(^start)(void);

@end
