//
// Created by lihui on 2017/3/4.
// Copyright (c) 2017 appgo. All rights reserved.
//

#import "DoubanBookViewModel.h"
#import "NAAPIService.h"
#import "NAAPIRequest.h"
#import "DoubanBookModel.h"

@implementation DoubanBookViewModel

- (void)fetchDoubanBook:(ViewModelCallback)callback {
    NAAPIRequest *request = [NAAPIRequest  new];
    request.requestURL = [NSURL URLWithString:@"https://api.douban.com/v2/book/1220562"];
    NAAPIService *api = [NAAPIService  new];
    [api request:request callback:^(NAAPIRequest *request, id result, NSError *error) {
        if (error == nil && [result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *bookInfo = (NSDictionary *)result;

            self.model = [[DoubanBookModel alloc] initWithDictionary:bookInfo error:nil];

            NSLog(@"title: %@",bookInfo[@"title"]);

            if (callback) {
                callback(self.model,nil);
            }
        }
    }];
}
@end