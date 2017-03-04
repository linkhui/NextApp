//
//  NAInteractionController.h
//  xiami
//
//  Created by  on 14/11/28.
//  Copyright (c) 2014年 xiami. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NAInteractionProtocol.h"
@interface NAInteractionController : UIPercentDrivenInteractiveTransition
<TTTransitionInteractionController, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIViewController *fromViewController;
@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic, assign) BOOL reverseGestureDirection;

//被替换的手势
@property (nonatomic ,strong)UIPanGestureRecognizer *replacedGestureRecognizer;


- (BOOL)isGesturePositive:(UIPanGestureRecognizer *)panGestureRecognizer;
- (CGFloat)swipeCompletionPercent;
- (CGFloat)translationPercentageWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer;
- (CGFloat)translationWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer;
@end
