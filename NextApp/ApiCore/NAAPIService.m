//
// Created by lihui on 2017/3/4.
// Copyright (c) 2017 appgo. All rights reserved.
//

#import "NAAPIService.h"
#import "NAAPIRequest.h"

#import <AFNetworking/AFNetworking.h>

@implementation NAAPIService

- (void)request:(NAAPIRequest *)request callback:(APIServiceCallback)callback {

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:[request.requestURL absoluteString]
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             NSLog(@"%@ request success",request.requestURL);
             if (callback) {
                 callback(request,responseObject,nil);
             }
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@ request fail",request.requestURL);
             if (callback) {
                 callback(request,nil,error);
             }
         }];
}

@end
