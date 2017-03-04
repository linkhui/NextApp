//
//  NAModalCrossDissolveAnimationController.m
//  TTUISkeleton
//
//  Created by alibaba on 16/11/25.
//  Copyright © 2016年 Taobao lnc. All rights reserved.
//

#import "NAModalCrossDissolveAnimationController.h"

@interface NAModalCrossDissolveAnimationController ()

@end

@implementation NAModalCrossDissolveAnimationController

////////////////////////////////////////////////////////////////////////////////
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    UIView *containerView = [self containerView];
    containerView.backgroundColor = [UIColor whiteColor];
    UIView *fromView = self.fromView;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIView *toView = self.toView;
    CGRect frameForToViewController = [containerView bounds];
    toView.frame = frameForToViewController;
    if (self.isPositiveAnimation) {  //pop
        [containerView insertSubview:toView belowSubview:fromView];
    } else {  //push
        [containerView addSubview:toView];
        fromView.alpha = 0.7;
        toView.alpha = 0.7;
    }
    [UIView animateWithDuration:[self transitionDuration:self.transitionContext]
                          delay:0
                        options:(self.isPositiveAnimation) ?  UIViewAnimationOptionCurveEaseOut : UIViewAnimationOptionCurveEaseIn
                     animations:^
     {
         fromView.alpha = 0;
         toView.alpha = 1;
     } completion:^(BOOL finished) {
         [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
         [self handleWhenTransitionCompleted];
     }];
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

@end





















