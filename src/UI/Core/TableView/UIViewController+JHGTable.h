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

@property (nonatomic, strong) NSMutableArray *jhg_dataArray;

@property (nonatomic, strong) IBOutlet UITableView *jhg_mainTableView;

// call this in viewDidLoad to use JHGTable
- (void)jhg_setupJHGTableView;

// use only one of the two methods below in one vc, dont mix
- (void)addCell:(JHCellConfig *)cellConfig;
- (void)addSectionCells:(NSArray <__kindof JHCellConfig *> *)cellConfigs;
// removeAllObjects of dataArray
- (void)clearCells;

- (JHCellConfig *)jhg_cellConfigOfIndexPath:(NSIndexPath *)indexPath;


// to rewrite
- (UITableViewStyle)jhg_getTableStyle;
- (UITableViewCellSeparatorStyle)jhg_getSeparatorStyle;
- (UIColor *)jhg_getSeparatorColor;
- (UIColor *)jhg_getTableViewBackgroundColor;

#pragma mark - refresh header footer

- (BOOL)jhg_needRefreshHeader;
- (void)jhg_refreshHeaderAction;
- (BOOL)jhg_needRefreshFooter;
- (void)jhg_refreshFooterAction;
- (void)jhg_triggerRefreshManully;
- (void)jhg_endHeaderFooterRefreshing;
- (void)jhg_setNoMoreData;
- (void)jhg_resetNoMoreData;


@end

