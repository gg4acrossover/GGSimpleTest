//
//  GGBtnAnim.h
//  GGSimpleTest
//
//  Created by viethq on 9/29/15.
//  Copyright © 2015 viethq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSpinerLayer.h"

typedef void(^Completion)();

@interface GGBtnAnim : UIButton

@property (nonatomic,retain) GGSpinerLayer *mSpiner;
@property (nonatomic, assign) CGFloat mDuration;

-(void)setCompletion:(Completion)completion;
-(void)StartAnimation;
-(void)ErrorRevertAnimationCompletion:(Completion)completion;
-(void)ExitAnimationCompletion:(Completion)completion;

@end
