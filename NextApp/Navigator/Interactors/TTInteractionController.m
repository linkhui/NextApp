//
//  TTInteractionController.m
//  xiami
//
//  Created by Li Jianfeng on 14/11/28.
//  Copyright (c) 2014年 xiami. All rights reserved.
//

#import "TTInteractionController.h"
#import "NAViewController.h"
#define kXInteractionDefaultCompletionPercentage  0.3f

@implementation TTInteractionController{
    BOOL  _isReplacedGestureBegan;
}
@synthesize style = _style;
@synthesize isInteractive = _isInteractive;
@synthesize nextViewControllerDelegate = _delegate;
@synthesize shouldCompleteTransition = _shouldCompleteTransition;

- (id)init
{
    self = [super init];
    if (self) {
        _reverseGestureDirection = NO;
    }
    return self;
}

- (void)attachViewController:(NAViewController *)viewController withStyle:(TTTransitionStyle)style
{
    self.fromViewController = viewController;
    self.style = style;
    if (viewController.customBackGesture) {
        self.replacedGestureRecognizer = viewController.customBackGesture;
    }else{
        [self attachGestureRecognizerToView:self.fromViewController.view];
    }
    
}

- (void)setReplacedGestureRecognizer:(UIPanGestureRecognizer *)replacedGestureRecognizer{
    _replacedGestureRecognizer = replacedGestureRecognizer;
    [_replacedGestureRecognizer addTarget:self action:@selector(handleReplacedPanGesture:)];
    [self.fromViewController.view addGestureRecognizer:_replacedGestureRecognizer];
}

- (void)attachGestureRecognizerToView:(UIView*)view {
    [view addGestureRecognizer:self.gestureRecognizer];
}

-(void)dealloc
{
    [self.gestureRecognizer.view removeGestureRecognizer:self.gestureRecognizer];
}


#pragma mark - UIPanGestureRecognizer Delegate
- (void)handleReplacedPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer{
    if ([panGestureRecognizer.delegate isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)panGestureRecognizer.delegate;
        if (scrollView.contentOffset.x <=0 || _isReplacedGestureBegan) {
            _isReplacedGestureBegan = YES;
            [self handlePanGesture:panGestureRecognizer];
        }
        if ((panGestureRecognizer.state == UIGestureRecognizerStateEnded) ||
            (panGestureRecognizer.state == UIGestureRecognizerStateCancelled) ||
            (panGestureRecognizer.state == UIGestureRecognizerStateFailed)) {
            _isReplacedGestureBegan = NO;
        }
    }
}


- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGFloat percentage = [self translationPercentageWithPanGestureRecongizer:panGestureRecognizer];
    BOOL positiveDirection = self.reverseGestureDirection ? ![self isGesturePositive:panGestureRecognizer] : [self isGesturePositive:panGestureRecognizer];
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (positiveDirection) {
                if ( self.nextViewControllerDelegate && [self.nextViewControllerDelegate conformsToProtocol:@protocol(TTTransitionInteractionControllerDelegate)]) {
                    self.isInteractive = YES;
                    [self pushPlayViewController];
                }
            }else{
                 self.isInteractive = YES;
                 [self.fromViewController.navigationController popViewControllerAnimated:YES];
            }
            
            break;
            
        case UIGestureRecognizerStateChanged:
            if (self.isInteractive){
                self.shouldCompleteTransition = (percentage > [self swipeCompletionPercent]);
                [self updateInteractiveTransition:percentage];
            }
            break;
            
        case UIGestureRecognizerStateCancelled:
            self.isInteractive = NO;
            [self cancelInteractiveTransition];
            break;
            
        case UIGestureRecognizerStateEnded:
            if (self.isInteractive)
            {
                self.isInteractive = NO;
                if (!self.shouldCompleteTransition || panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                    [self cancelInteractiveTransition];
                }
                else {
                    [self finishInteractiveTransition];
                }
            }
            
        default:
            break;
    }
}

-(void)pushPlayViewController
{
    UIViewController *pushController = [self.nextViewControllerDelegate nextViewControllerForInteractor:self];
    NSArray *controllers = [self.fromViewController.navigationController viewControllers];
    BOOL isExist = NO;
    for ( UIViewController *viewController in controllers) {
        if ([viewController isEqual:pushController]) {
            isExist = YES;
            break;
        }
    }
    if (isExist == YES) {
        [self.fromViewController.navigationController popToViewController:pushController animated:YES];
    }else{
        [self.fromViewController.navigationController pushViewController:pushController animated:YES];
    }
}

- (BOOL)isGesturePositive:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return NO;
}

- (CGFloat)swipeCompletionPercent
{
    return kXInteractionDefaultCompletionPercentage;
}

- (CGFloat)translationPercentageWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0.0f;
}

- (CGFloat)translationWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0.0f;
}

#pragma mark - Overridden Properties

- (UIGestureRecognizer*)gestureRecognizer
{
    if (!_gestureRecognizer)
    {
        _gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [_gestureRecognizer setDelegate:self];
    }
    return _gestureRecognizer;
}

@end

