//
//  NARouterResult.h
//  Pods
//
//  Created by  on 16/1/30.
//
//

#import <Foundation/Foundation.h>
/*
 *
 *router处理结果类
 *
 *
 */
@interface NARouterResult : NSObject
//是否找到了处理对象
@property (nonatomic ,assign)BOOL canFindHandler;
//router处理对象返回的结果，只支持id类型，void返回nil
@property (nonatomic ,strong)id hanleResult;
@end
