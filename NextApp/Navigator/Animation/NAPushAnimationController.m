//
//  XPushAnimationController.m
//  xiami
//
//  Created by  on 14/11/28.
//  Copyright (c) 2014年 xiami. All rights reserved.
//

#import "NAPushAnimationController.h"
#define kTTPushTransitionTime 0.35
@interface NAPushAnimationController()
@property(nonatomic,assign)CGFloat navigationBarOffset;
@end
@implementation NAPushAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    self.transitionContext = transitionContext;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *container = [transitionContext containerView];

    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    
    UINavigationBar *navigationBar = toViewController.navigationController.navigationBar;
    navigationBar.alpha = 1.0;
    
    CGFloat navigationBarOffset = [UIApplication sharedApplication].statusBarFrame.size.height + navigationBar.frame.size.height;
    CGFloat toViewStatusBarOffset= 0;
    self.navigationBarOffset = navigationBarOffset;
    
    
    BOOL navigationBarChanged = NO;// (toViewHideNavi != fromViewHideNavi) ;
    BOOL showNavi = NO;//!toViewHideNavi && navigationBarChanged;
    BOOL hideNavi= NO;//toViewHideNavi &&  navigationBarChanged;
    
    CGPoint originNavigationBarCenter = navigationBar.center;
    
     CGPoint  finalNavigationBarCenter = originNavigationBarCenter;
    
    
    
    
    if (self.isPositiveAnimation) {
        [container insertSubview:toView belowSubview:fromView];
        CGRect beforeFrame =toView.frame;
        
        if (hideNavi) {//返回隐藏navibar toView向上移
            beforeFrame.origin.y -= navigationBarOffset;
            beforeFrame.size.height += navigationBarOffset;
            CGPoint animatedP = originNavigationBarCenter;
            animatedP.x *= 3;
            finalNavigationBarCenter =animatedP;
            beforeFrame.origin.y += toViewStatusBarOffset;
        }
        if (showNavi) {//返回显示navibar toView向上移
            beforeFrame.origin.y += navigationBarOffset;
            beforeFrame.size.height -= navigationBarOffset;
            
            CGPoint center = originNavigationBarCenter;
            center.x =center.x -center.x*2;
            navigationBar.center =center;
        }
        
         CGRect frame = fromView.frame;
         frame.origin.x = frame.origin.x + frame.size.width;
        
        
        beforeFrame.origin.x=-50;//偏移效果
        

        toView.frame = beforeFrame;
        CGRect toViewFinalFrame = beforeFrame;
        toViewFinalFrame.origin.x = 0;
        
        CGRect shadowFrame = fromView.frame;
        shadowFrame.size.width=1;
        UIView *shadowView = [[UIView alloc]initWithFrame:shadowFrame];
        [container insertSubview:shadowView belowSubview:fromView];
        shadowFrame =frame;
        shadowFrame.size.width =1;
        [self shadowView:shadowView];
        
        UIView *maskView = [[UIView alloc]initWithFrame:toViewFinalFrame];
        maskView.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [container insertSubview:maskView aboveSubview:toView];
        
        
        [UIView animateWithDuration:kTTPushTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             if (navigationBarChanged) {
                                 navigationBar.center = finalNavigationBarCenter;
                             }
                             fromView.frame =  frame;
                             toView.frame =toViewFinalFrame;
                             shadowView.frame = shadowFrame;
                             shadowView.alpha =0;
                             maskView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             if (navigationBarChanged) {
                                 navigationBar.center = originNavigationBarCenter;
                             }
                             [navigationBar.layer removeAllAnimations];
                             [shadowView removeFromSuperview];
                             [maskView removeFromSuperview];
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                             [self handleWhenTransitionCompleted];
                         }];
    } else {
        [container addSubview:toView];
        CGRect frame =toView.frame;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
         CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGRect beforeFrame =CGRectMake(0, 0, screenWidth, screenHeight);

        beforeFrame.origin.x = frame.size.width;
        
        if (showNavi) {
            beforeFrame.origin.y += navigationBarOffset;
            beforeFrame.size.height -= navigationBarOffset;
            
            CGPoint center = originNavigationBarCenter;
            center.x *=3;

        }
        CGPoint  finalNavigationBarCenter = originNavigationBarCenter;
        
        
        if (hideNavi) {
            beforeFrame.origin.y -= navigationBarOffset;
            beforeFrame.size.height += navigationBarOffset;
            navigationBar.center =originNavigationBarCenter;
            CGPoint center = originNavigationBarCenter;
            center.x =center.x -center.x*3;
            finalNavigationBarCenter =center;
        }
        
        //实现偏移效果
        CGRect fromFinalFrame = fromView.frame;
        fromFinalFrame.origin.x =-50;
        
        toView.frame = beforeFrame;
        
        beforeFrame.origin.x = 0;
      
        [UIView animateWithDuration:kTTPushTransitionTime
                              delay:0
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             toView.frame = beforeFrame;
                             fromView.frame = fromFinalFrame;
                             if (navigationBarChanged) {
                                 navigationBar.center =finalNavigationBarCenter;
                             }
                         }
                         completion:^(BOOL finished) {
                            [navigationBar.layer removeAllAnimations];
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                             [self handleWhenTransitionCompleted];
                         }];
        
   
    }
}
-(void)shadowView:(UIView *)view{
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowRadius = 4.0f;
   view.layer.shadowOffset = CGSizeMake(-2, -1);
   view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    view.layer.masksToBounds = NO;
}

-( CGPoint)navigationBarBeginCenter:(BOOL)showNavi originNavigationBarCenter:(CGPoint)orginCenter{
    CGPoint navigationBarBeginCenter = orginCenter;
    if (self.isPositiveAnimation) {
        if (showNavi) {
            CGPoint center = orginCenter;
            center.x =center.x -center.x*2;
            navigationBarBeginCenter =  center;
        }
    }else{
        if (showNavi) {
            CGPoint center = orginCenter;
            center.x *=3;
            navigationBarBeginCenter = center;
        }
    }
    return navigationBarBeginCenter;
}
-( CGPoint)navigationBarFinishCenter:(BOOL)showNavi
           originNavigationBarCenter:(CGPoint)orginCenter{
    CGPoint navigationBarFinishCenter = orginCenter;
    if (self.isPositiveAnimation) {
        if (!showNavi) {
            CGPoint animatedP = orginCenter;
            animatedP.x *= 3;
            navigationBarFinishCenter =animatedP;
        }
        
    }else{
        if (!showNavi) {
            CGPoint center = orginCenter;
            center.x =center.x -center.x*3;
            navigationBarFinishCenter =center;
        }
    }
    return navigationBarFinishCenter;
}


-( CGRect)toViewBeginFrame:(BOOL)showNavi{
    //todo
    return CGRectZero;
}
-(CGRect)toViewFinishFrame:(BOOL)showNavi{
    //todo
     return CGRectZero;
}
-( CGRect)fromViewBeginFrame:(BOOL)showNavi{
    //todo
    return CGRectZero;
}
-(CGRect)fromViewFinishFrame:(BOOL)showNavi{
    //todo
    return CGRectZero;
}




-(void)pushViewController:(UIViewController *)fromViewController
         toViewController:(UIViewController *)toViewController
                container:(UIView *)containerView{
    
    
}


-(void)popViewController:(UIViewController *)fromViewController
        toViewController:(UIViewController *)toViewController
               container:(UIView *)containerView{
    
    
}
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kTTPushTransitionTime;
}
@end
