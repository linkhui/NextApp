//
//  TTRouting.h
//  TTUISkeleton
//
//  Created by guanshanliu on 11/20/15.
//  Copyright © 2015 TTPod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTRouterResult.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TTRouting <NSObject>

- (TTRouterResult *)route:(NSString *)urlString
                withParam:(nullable NSDictionary *)param;

- (TTRouterResult *)route:(NSString *)urlString
                withParam:(nullable NSDictionary *)param
       fromViewController:(UIViewController *)viewController;

- (BOOL)couldRouteBySchemeHandler:(NSString *)urlString;

@optional

- (TTRouterResult *)route:(NSString *)urlString
                withParam:(nullable NSDictionary *)param
          withRequestCode:(NSInteger)requestCode;

- (TTRouterResult *)route:(NSString *)urlString
                withParam:(nullable NSDictionary *)param
       fromViewController:(UIViewController *)viewController
          withRequestCode:(NSInteger)requestCode;

@end

NS_ASSUME_NONNULL_END
