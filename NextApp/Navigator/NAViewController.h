//
//  NAViewController.h
//  NextApp
//
//  Created by lihui on 2017/3/4.
//  Copyright © 2017年 appgo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TTViewControllerPresentStyle) {
    TTViewControllerPresentStyleNone,
    TTViewControllerPresentStylePush,
    TTViewControllerPresentStyleModal,
    TTViewControllerPresentStyleModalCrossDissolve
};


@protocol TTViewControllerNavigatingStyle <NSObject>

@property (nonatomic, readonly) TTViewControllerPresentStyle presentStyle;
//自定义手势返回的手势，目前只支持scrlloview第一页手势返回
//用法如：self.customBackGesture = self.scrollView.panGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *customBackGesture;

@end

@interface NAViewController : UIViewController <TTViewControllerNavigatingStyle>

-(BOOL)canDismissWithGesture;

@end
