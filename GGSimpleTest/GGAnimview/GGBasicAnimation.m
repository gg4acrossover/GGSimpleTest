//
//  GGBasicAnimation.m
//  GGSimpleTest
//
//  Created by viethq on 9/3/15.
//  Copyright (c) 2015 viethq. All rights reserved.
//

#import "GGBasicAnimation.h"

@implementation GGBasicAnimation

+(instancetype)animationWithKeyPath:(NSString *)path
{
    GGBasicAnimation *pAnim = [super animationWithKeyPath:path];
    pAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    pAnim.delegate = pAnim;
    return pAnim;
}

-(void)animationDidStart:(CAAnimation *)anim
{
    if (self.start)
    {
        self.start();
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.completion)
    {
        self.completion(flag);
    }
}

@end
