//
//  DoubanBookModel.h
//  NextApp
//
//  Created by lihui on 2017/3/4.
//  Copyright © 2017年 appgo. All rights reserved.
//

#import "NABaseModel.h"
@protocol DoubanBookModel

@end

@interface DoubanBookModel : NABaseModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *summary;

@end

@interface DoubanBooksModel : NABaseModel

@property (nonatomic, strong) NSArray<DoubanBookModel> *books;

@end
