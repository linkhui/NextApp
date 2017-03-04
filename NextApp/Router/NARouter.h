//
//  NARouter.h
//  TTUISkeleton
//
//  Created by guanshanliu on 11/20/15.
//  Copyright © 2015 TTPod. All rights reserved.
//

#import "NARouting.h"
@interface NARouter : NSObject <NARouting>
/*
 * Router单例
 */
+ (instancetype)defaultRouter;
/*
 * 添加到默认scheme：nextapp下
 *@param pattern: 需要匹配的正则字符串
 *@param handlerClassName: 处理对象的类名
 *@param selectorName: 处理对象的方法名
 */

- (void)addPattern:(NSString*)pattern
    withHandlerClassName:(NSString *)handlerClassName
      selectorName:(NSString *)selectorName;

/*
 * 添加到指定scheme下，如ttpod ，http，xiami等
 *@param pattern: 需要匹配的正则字符串
 *@param handlerClassName: 处理对象的类名
 *@param selectorName: 处理对象的方法名
 *@param scheme: 指定的scheme名
 */
- (void)addPattern:(NSString *)pattern
    withHandlerClassName:(NSString *)handlerClassName
      selectorName:(NSString *)selectorName
         forScheme:(NSString *)scheme;
@end
