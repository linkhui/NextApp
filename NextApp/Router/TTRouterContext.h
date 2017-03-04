//
//  TTRouterContext.h
//  Pods
//
//  Created by Li Jianfeng on 15/12/2.
//
//

#import <Foundation/Foundation.h>

@interface TTRouterContext : NSObject
@property (nonatomic ,strong) NSURL *url;
@property (nonatomic ,strong) NSArray *matchPaths;
@property (nonatomic ,strong) NSDictionary* queryParams;
@property (nonatomic ,assign) BOOL handled; // 没有使用，一直是NO
+(TTRouterContext *)contextWithUrl:(NSURL *)url matchPaths:(NSArray *)matchPaths queryParam:(NSDictionary *)queryParams;
@end
