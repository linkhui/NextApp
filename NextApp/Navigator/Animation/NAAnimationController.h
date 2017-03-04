//
//  XAnimationController.h
//  xiami
//
//  Created by Li Jianfeng on 14/11/28.
//  Copyright (c) 2014年 xiami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@protocol TTViewControllerAnimatedTransitioning <UIViewControllerAnimatedTransitioning>
@end
@interface NAAnimationController : NSObject<TTViewControllerAnimatedTransitioning>
@property (nonatomic ,assign)BOOL isPositiveAnimation;

@property (strong, nonatomic) id <UIViewControllerContextTransitioning>transitionContext; //需要在动画结束后设置成nil
- (UIViewController *)fromViewController;
- (UIViewController *)toViewController;
- (UIView *)fromView;
- (UIView *)toView;
- (UIView *)containerView;
- (void)handleWhenTransitionCompleted;
@end
