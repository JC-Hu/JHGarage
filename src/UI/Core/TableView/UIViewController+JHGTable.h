//
//  UIViewController+JHGTable.h
//  JHGarage
//
//  Created by Jason Hu on 2019/1/4.
//  Copyright © 2019 Jason Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JHGBlankCell.h"
#import <MJRefresh/MJRefresh.h>

@interface UIViewController (JHGTable) <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) IBOutlet UITableView *mainTableView;

- (JHCellConfig *)cellConfigOfIndexPath:(NSIndexPath *)indexPath;

// to rewrite
- (UITableViewStyle)getTableStyle;
- (UITableViewCellSeparatorStyle)getSeparatorStyle;
- (UIColor *)getSeparatorColor;
- (UIColor *)getTableViewBackgroundColor;

#pragma mark - refresh header footer
//@property (nonatomic, assign) NSInteger pageSize;
//@property (nonatomic, assign) NSInteger pageCount;

- (BOOL)needRefreshHeader;
- (void)refreshHeaderAction;
- (BOOL)needRefreshFooter;
- (void)refreshFooterAction;
- (void)triggerRefreshManully;
- (void)endHeaderFooterRefreshing;

@end

