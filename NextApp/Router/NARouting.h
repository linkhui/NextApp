//
//  NARouting.h
//  TTUISkeleton
//
//  Created by guanshanliu on 11/20/15.
//  Copyright © 2015 TTPod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NARouterResult.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NARouting <NSObject>

- (NARouterResult *)route:(NSString *)urlString
                withParam:(nullable NSDictionary *)param;

- (NARouterResult *)route:(NSString *)urlString
                withParam:(nullable NSDictionary *)param
       fromViewController:(UIViewController *)viewController;

- (BOOL)couldRouteBySchemeHandler:(NSString *)urlString;

@optional

- (NARouterResult *)route:(NSString *)urlString
                withParam:(nullable NSDictionary *)param
          withRequestCode:(NSInteger)requestCode;

- (NARouterResult *)route:(NSString *)urlString
                withParam:(nullable NSDictionary *)param
       fromViewController:(UIViewController *)viewController
          withRequestCode:(NSInteger)requestCode;

@end

NS_ASSUME_NONNULL_END
