//
//  XModalAnimationController.m
//  xiami
//
//  Created by Li Jianfeng on 14/12/1.
//  Copyright (c) 2014年 xiami. All rights reserved.
//

#import "NAModalAnimationController.h"
#define kTTModalTransitionTime 0.35
@implementation NAModalAnimationController
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    self.transitionContext = transitionContext;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *container = [transitionContext containerView];
    
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    
    UINavigationBar *navigationBar = toViewController.navigationController.navigationBar;
    navigationBar.alpha =1.0;
    
    CGFloat navigationBarOffset = [UIApplication sharedApplication].statusBarFrame.size.height + navigationBar.frame.size.height;
  
//    BOOL navigationBarChanged = NO;//toViewHideNavi != fromViewHideNavi ;
    BOOL showNavi = NO;//!toViewHideNavi && navigationBarChanged;
    BOOL hideNavi=  NO;//toViewHideNavi &&  navigationBarChanged;
    
    CGPoint originNavigationBarCenter = navigationBar.center;
    
//    CGPoint  finalNavigationBarCenter = originNavigationBarCenter;
    
      CGFloat offset = [UIApplication sharedApplication].statusBarFrame.size.height + toViewController.navigationController.navigationBar.frame.size.height;
    if (self.isPositiveAnimation) {
        if ([toViewController isKindOfClass:NSClassFromString(@"XMvPlayerViewController")]) {
            [container insertSubview:toView belowSubview:fromView];
            [fromView removeFromSuperview];
            [transitionContext completeTransition:YES];
            
            return;
        }
        [container insertSubview:toView belowSubview:fromView];
    
        CGRect beforeFrame =toView .frame;
        if (hideNavi) {
            beforeFrame.origin.y -= offset;
            beforeFrame.size.height += offset;
        }
        toView.frame = beforeFrame;
        CGRect frame = fromViewController. view.frame;
        frame.origin.y = frame.origin.y + frame.size.height;
//        CGPoint navigationBarCenter= fromViewController.navigationController.navigationBar.center;
        UIView *view = [UIView new];
        view.frame = toViewController.view.bounds;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.8;
        
        [UIView animateWithDuration:kTTModalTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             if (hideNavi) {
                                 CGPoint center = navigationBar.center;
                                 CGFloat toViewHeight = toView.frame.size.height;
                                 CGFloat toViewWidth = toView.frame.size.width;
                                 
                                 center.y += toViewHeight > toViewWidth ? toViewHeight : toViewWidth;
                                 navigationBar.center = center;
                             }
                             fromView.frame =  frame;
                             view.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [navigationBar.layer removeAllAnimations];
                             if (finished) {
                                 [view removeFromSuperview];
                             }
                             navigationBar.center =originNavigationBarCenter;
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                             [self handleWhenTransitionCompleted];
                         }];
    } else {
        [container addSubview:toView];
        CGRect frame =toView.frame;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGRect beforeFrame =CGRectMake(0, 0, screenWidth, screenHeight);
        
        beforeFrame.origin.y = frame.size.height;
        toView.frame = beforeFrame;
        beforeFrame.origin.y=frame.origin.y;
        if (showNavi) {
            beforeFrame.origin.y += navigationBarOffset;
            beforeFrame.size.height -= navigationBarOffset;
        }

        if (hideNavi) {
            beforeFrame.origin.y -= navigationBarOffset;
            beforeFrame.size.height += navigationBarOffset;
        }
     
   
        
        UIView *view = [UIView new];
        view.frame = fromViewController.view.bounds;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0;
        [fromViewController.view addSubview:view] ;
        [UIView animateWithDuration:kTTModalTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toView.frame = beforeFrame;
                             view.alpha = 0.8;
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 [view removeFromSuperview];
                             }
                             [navigationBar.layer removeAllAnimations];
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                             [self handleWhenTransitionCompleted];
                         }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kTTModalTransitionTime;
}
@end
