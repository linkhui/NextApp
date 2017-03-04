//
//  NATableViewController.h
//  TTUISkeleton
//
//  Created by guanshanliu on 11/20/15.
//  Copyright © 2015 TTPod. All rights reserved.
//

#import "NAViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NATableViewController : NAViewController <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithStyle:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

/**
 *  defaults to `UITableViewStylePlain`
 */
@property (nonatomic, assign) UITableViewStyle style;
@property (nonatomic, strong, null_resettable) UITableView *tableView;
/// defaults to YES. If YES, any selection is cleared in viewWillAppear:
@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;

@end

NS_ASSUME_NONNULL_END