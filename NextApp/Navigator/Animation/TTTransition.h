//
//  XTransition.h
//  xiami
//
//  Created by Li Jianfeng on 14/11/28.
//  Copyright (c) 2014年 xiami. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM (NSInteger, TTTransitionStyle) {
    TTTransitionStylePush             = (1 << 0),
    TTTransitionStylePresent          = (1 << 1),
    TTTransitionStyleShare          = (1 << 2),
   
};
@interface TTTransition : NSObject

@property (assign, nonatomic) TTTransitionStyle transitionStyle;


@property (assign, nonatomic) Class fromViewControllerClass;

@property (assign, nonatomic) Class toViewControllerClass;



@end
