//
// Created by lihui on 2017/3/4.
// Copyright (c) 2017 appgo. All rights reserved.
//

#import "DoubanBookViewModel.h"
#import "NAAPIService.h"
#import "NAAPIRequest.h"
#import "DoubanBookModel.h"

//https://api.douban.com/v2/book/1220562

@implementation DoubanBookViewModel

- (void)fetchDoubanBook:(ViewModelCallback)callback {
    NAAPIRequest *request = [NAAPIRequest  new];
    request.requestURL = [NSURL URLWithString:@"https://api.douban.com/v2/book/search?q=%E5%AF%93%E8%A8%80%E6%95%85%E4%BA%8B"];
    NAAPIService *api = [NAAPIService  new];
    [api request:request callback:^(NAAPIRequest *request, id result, NSError *error) {
        if (error == nil && [result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *bookInfo = (NSDictionary *)result;

            self.model = [[DoubanBooksModel alloc] initWithDictionary:bookInfo error:nil];

            if (callback) {
                callback(self.model,nil);
            }
        }
    }];
}

- (NSInteger)booksCount {
    return [self.model.books count];
}
@end
