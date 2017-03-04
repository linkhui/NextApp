//
//  NSObject+TTRouter.m
//  TTUISkeleton
//
//  Created by guanshanliu on 11/20/15.
//  Copyright © 2015 TTPod. All rights reserved.
//

#import "NSObject+TTRouter.h"
#import "TTRouter.h"

@implementation NSObject (TTRouter)

- (id)route:(NSString *)urlString withParam:(NSDictionary *)param {
    return   [[TTRouter defaultRouter] route:urlString withParam:param];
}

- (id)route:(NSString *)urlString withParam:(NSDictionary *)param fromViewController:(UIViewController *)viewController {
    return   [[TTRouter defaultRouter] route:urlString withParam:param fromViewController:viewController];
}

- (BOOL)couldRouteBySchemeHandler:(NSString *)urlString {
    return [[TTRouter defaultRouter] couldRouteBySchemeHandler:urlString];
}


@end
