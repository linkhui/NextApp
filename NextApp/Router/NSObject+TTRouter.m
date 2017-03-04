//
//  NSObject+NARouter.m
//  TTUISkeleton
//
//  Created by guanshanliu on 11/20/15.
//  Copyright © 2015 TTPod. All rights reserved.
//

#import "NSObject+TTRouter.h"
#import "NARouter.h"

@implementation NSObject (TTRouter)

- (id)route:(NSString *)urlString withParam:(NSDictionary *)param {
    return   [[NARouter defaultRouter] route:urlString withParam:param];
}

- (id)route:(NSString *)urlString withParam:(NSDictionary *)param fromViewController:(UIViewController *)viewController {
    return   [[NARouter defaultRouter] route:urlString withParam:param fromViewController:viewController];
}

- (BOOL)couldRouteBySchemeHandler:(NSString *)urlString {
    return [[NARouter defaultRouter] couldRouteBySchemeHandler:urlString];
}


@end
