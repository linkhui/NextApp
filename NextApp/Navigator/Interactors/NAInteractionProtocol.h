//
//  XInteractionProtocol.h
//  xiami
//
//  Created by Li Jianfeng on 14/11/28.
//  Copyright (c) 2014年 xiami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

#import "NATransition.h"
@protocol TTTransitionInteractionController;
@protocol TTTransitionInteractionControllerDelegate;

@protocol TTTransitionInteractionControllerDelegate <NSObject>

@optional

- (UIViewController *)nextViewControllerForInteractor:(id<TTTransitionInteractionController>)interactor;

@end

@protocol TTTransitionInteractionController <UIViewControllerInteractiveTransitioning>

@required

@property (nonatomic, assign, readwrite) BOOL isInteractive;

@property (nonatomic, assign, readwrite) BOOL shouldCompleteTransition;

@property (nonatomic, assign, readwrite) TTTransitionStyle style;

@property (nonatomic, weak) id<TTTransitionInteractionControllerDelegate> nextViewControllerDelegate;


- (void)attachViewController:(UIViewController *)viewController withStyle:(TTTransitionStyle)style;
@end
