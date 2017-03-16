//
//  GGFacebookReactionsVCViewController.m
//  GGSimpleTest
//
//  Created by VietHQ on 12/2/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import "GGFacebookReactionsVC.h"

@interface GGFacebookReactionsVC ()

@property (weak, nonatomic) IBOutlet UIButton *reactionBtn;

@property (strong, nonatomic) UIView *containerReationsView;

@end

@implementation GGFacebookReactionsVC

#pragma mark - View life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.containerReationsView = [UIView new];
    
    [self.view addSubview:self.containerReationsView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareContainerReactionsView];
}

#pragma mark - Action callback
- (IBAction)clickReactionsBtnCallback:(id)sender
{
    //self.reactionBtn.enabled = NO;
    
    CGRect f = self.containerReationsView.frame;
    __block CGRect newFrame = f;
    
    [UIView animateWithDuration:0.3f delay:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        newFrame.origin.y -= 80.0f;
        self.containerReationsView.frame = newFrame;
        
    } completion:^(BOOL finished) {
        self.containerReationsView.frame = f;
    }];
    
}

#pragma mark - Common
- (void)prepareContainerReactionsView
{
    CGFloat edge = 4.0f;
    
    self.containerReationsView.frame = CGRectMake( self.reactionBtn.frame.origin.x - edge, self.reactionBtn.frame.origin.y - edge, 300.0f, self.reactionBtn.frame.size.height + 2*edge);
    
    self.containerReationsView.layer.cornerRadius = CGRectGetHeight(self.containerReationsView.frame)*0.5f;
    
    self.containerReationsView.layer.masksToBounds = YES;
    
    self.containerReationsView.layer.borderColor = [UIColor blackColor].CGColor;
    self.containerReationsView.layer.borderWidth = 0.5f;
    self.containerReationsView.userInteractionEnabled = NO;
}

@end
