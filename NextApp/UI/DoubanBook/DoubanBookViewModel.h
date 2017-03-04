//
// Created by lihui on 2017/3/4.
// Copyright (c) 2017 appgo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DoubanBookModel;

typedef void(^ViewModelCallback)(id result, NSError *error);

@interface DoubanBookViewModel : NSObject

@property (nonatomic, strong)DoubanBookModel *model;

- (void)fetchDoubanBook:(ViewModelCallback)callback;

@end