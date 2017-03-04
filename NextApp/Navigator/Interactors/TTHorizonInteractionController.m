//
//  XHorizonInteractionController.m
//  xiami
//
//  Created by Li Jianfeng on 14/11/28.
//  Copyright (c) 2014年 xiami. All rights reserved.
//

#import "TTHorizonInteractionController.h"

#define kTTHorizontalTransitionCompletionPercentage 0.3f

@implementation TTHorizonInteractionController

- (BOOL)isGesturePositive:(UIPanGestureRecognizer *)panGestureRecognizer
{
    return [self translationWithPanGestureRecongizer:panGestureRecognizer] < 0;
}

- (CGFloat)swipeCompletionPercent
{
    return kTTHorizontalTransitionCompletionPercentage;
}

- (CGFloat)translationPercentageWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    return [self translationWithPanGestureRecongizer:panGestureRecognizer] / panGestureRecognizer.view.bounds.size.width;
}

- (CGFloat)translationWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    return [panGestureRecognizer translationInView:panGestureRecognizer.view].x;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer*)gestureRecognizer;
//        CGFloat yTranslation = [panGestureRecognizer translationInView:panGestureRecognizer.view].y;
        
        CGPoint xTranslation=   [panGestureRecognizer velocityInView:panGestureRecognizer.view];
        return xTranslation.x>0;
//        return yTranslation == 0 ;
    }
    
    return YES;
}
@end
