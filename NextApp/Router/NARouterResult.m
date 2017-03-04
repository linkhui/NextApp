//
//  NARouterResult.m
//  Pods
//
//  Created by Li Jianfeng on 16/1/30.
//
//

#import "NARouterResult.h"

@implementation NARouterResult

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"Handled: %@\nResult:%@", self.canFindHandler ? @"success" : @"failure", self.hanleResult];
    return description;
}

@end
