//
//  XAnimationController.m
//  xiami
//
//  Created by Li Jianfeng on 14/11/28.
//  Copyright (c) 2014年 xiami. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TTAnimationController.h"

#define kTTPushTransitionTime 0.35

static NSString * const TTViewControllerTransitionFromViewControllerKey = @"TTViewControllerTransitionFromViewControllerKey";
static NSString * const TTViewControllerTransitionToViewControllerKey = @"TTViewControllerTransitionToViewControllerKey";
static NSString * const TTViewControllerTransitioWasCancelledKey = @"TTViewControllerTransitioWasCancelledKey";
static NSString * const TTViewControllerTransitionDidCompleteNotification = @"TTViewControllerTransitionDidCompleteNotification";


@implementation TTAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{

}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kTTPushTransitionTime;
}

- (void)handleWhenTransitionCompleted {
    UIViewController *fromViewController = self.fromViewController;
    UIViewController *toViewController = self.toViewController;
    [[NSNotificationCenter defaultCenter] postNotificationName:TTViewControllerTransitionDidCompleteNotification
                                                        object:nil
                                                      userInfo:@{
                                                                 TTViewControllerTransitionFromViewControllerKey: fromViewController,
                                                                 TTViewControllerTransitionToViewControllerKey: toViewController,
                                                                 TTViewControllerTransitioWasCancelledKey: @([self.transitionContext transitionWasCancelled])
                                                                 }];
    self.transitionContext = nil;
}
////////////////////////////////////////////////////////////////////////////////
#pragma mark - getter
- (UIViewController *)fromViewController {
    if (self.transitionContext) {
        return [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    else {
        return nil;
    }
}

- (UIViewController *)toViewController {
    if (self.transitionContext) {
        return [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    else {
        return nil;
    }
}


- (UIView *)fromView {
    if (self.transitionContext) {
        UIView *fromView = nil;
        if ([self.transitionContext respondsToSelector:@selector(viewForKey:)]) {
            fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
        }
        else {
            fromView = self.fromViewController.view;
        }
        return fromView;
    }
    else {
        return nil;
    }
}

- (UIView *)toView {
    if (self.transitionContext) {
        UIView *toView = nil;
        if ([self.transitionContext respondsToSelector:@selector(viewForKey:)]) {
            toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
        }
        else {
            toView = self.toViewController.view;
        }
        return toView;
    }
    else {
        return nil;
    }
}

- (UIView *)containerView {
    return [self.transitionContext containerView];
}

- (UINavigationBar *)navigationBar {
    return self.toViewController.navigationController.navigationBar;
}
@end
