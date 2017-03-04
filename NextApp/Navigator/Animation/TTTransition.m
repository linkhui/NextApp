//
//  XTransition.m
//  xiami
//
//  Created by Li Jianfeng on 14/11/28.
//  Copyright (c) 2014年 xiami. All rights reserved.
//

#import "TTTransition.h"



@implementation TTTransition

#pragma mark - Equality overrides

- (instancetype)initWithAction:(TTTransitionStyle)style
   withFromViewControllerClass:(Class)fromViewController
     withToViewControllerClass:(Class)toViewController
{
    self = [super init];
    if (self) {
        _transitionStyle = style;
        _fromViewControllerClass = fromViewController;
        _toViewControllerClass = toViewController;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    TTTransition *copiedObject = [[[self class] allocWithZone:zone] init];
    
    copiedObject.transitionStyle = self.transitionStyle;
    copiedObject.toViewControllerClass = self.toViewControllerClass;
    copiedObject.fromViewControllerClass = self.fromViewControllerClass;
    
    return copiedObject;
}

- (NSUInteger)hash
{
    return [[self fromViewControllerClass] hash] ^ [[self toViewControllerClass] hash] ^ [self transitionStyle];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[TTTransition class]]) {
        return NO;
    }
    
    TTTransition *otherObject = (TTTransition *)object;
    
    return (otherObject.transitionStyle & self.transitionStyle) &&
    (otherObject.fromViewControllerClass == self.fromViewControllerClass) &&
    (otherObject.toViewControllerClass == self.toViewControllerClass);
}

@end
