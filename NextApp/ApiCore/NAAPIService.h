//
// Created by lihui on 2017/3/4.
// Copyright (c) 2017 appgo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NAAPIRequest;

typedef void(^APIServiceCallback)(NAAPIRequest *request, id result, NSError *error);

@interface NAAPIService : NSObject

- (void)request:(NAAPIRequest *)request callback:(APIServiceCallback)callback;

@end