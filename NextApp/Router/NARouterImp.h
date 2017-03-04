//
//  NARouterImp.h
//  Pods
//
//  Created by  on 15/11/30.
//
//

#import <Foundation/Foundation.h>
#import "NARouterContext.h"
#import "NARouterResult.h"
/*
 schemeurl 回调上下文
 
 url: 原始schemeurl
 matchPaths: 按正则匹配的path
 queryParams: 所有的查询参数，包括用户指定的 parameters
 handled: 指定是否处理了本schemeurl, 为false 时其它的回调可以继续处理, default = yes
 */

typedef NARouterResult* (^TTRoutehandler)(NARouterContext*  ctx);

@interface NARouterImp : NSObject
+(instancetype)instance;

/*
 返回指定前缀的sub router 处理器
 pattern: url 前缀
 
 exp:
 [[NARouterImp instance] newSubRouter:@"xiami://"];
 [[NARouterImp instance] newSubRouter:@"http://"]
 */
-(instancetype)newSubRouter:(NSString*)pattern;

/*
 处理 指定的url
 urlString: URL 字符串 exp: xiami://login
 parameters: 用户指定的参数 可以是任意参数
 asyn： 指定是异步执行
 
 @return: 返回schemeurl 处理函数的返回值，未处理返回nil， asyn = yes 时 直接返回 nil
 */
-(NARouterResult *)route:(NSString*)urlString;
-(NARouterResult *)route:(NSString *)urlString parameters:(NSDictionary*)parameters;
-(NARouterResult *)routeURL:(NSURL*)url;
-(NARouterResult *)routeURL:(NSURL*)url parameters:(NSDictionary*)parameters;
-(NARouterResult *)routeURL:(NSURL*)url parameters:(NSDictionary*)parameters asyn:(BOOL)basyn;

/*
 同步执行处理指定的url
 sec: 指定最大的超时秒数
 其它参数： 参考上面
 */
-(void)routeURL:(NSURL *)url parameters:(NSDictionary *)parameters waitSeconds:(double)sec;


/*
 添加指定的 schemeurl 处理器
 pattern： 正则匹配模式串
 block： 处理的handler
 */
-(void)addRoute:(NSString*)pattern block:(TTRoutehandler)handler;
-(void)addRoute:(NSString*)pattern withObject:(id)obj selector:(SEL)selector,...;


- (BOOL)couldRouteBySchemeHandler:(NSURL *)schemeURL;

@end

