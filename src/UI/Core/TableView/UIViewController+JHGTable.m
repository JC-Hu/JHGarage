//
//  UIViewController+JHGTable.m
//  JHGarage
//
//  Created by Jason Hu on 2019/1/4.
//  Copyright © 2019 Jason Hu. All rights reserved.
//

#import "UIViewController+JHGTable.h"

#import <objc/runtime.h>
#import "JHGSwizzle.h"

static NSString * const JHCellConfig_Key_DataArray;
static NSString * const JHCellConfig_Key_MainTableView;

@implementation UIViewController (DXZJHGTable)

- (void)jhg_setupJHGTableView
{
    [self.view addSubview:self.jhg_mainTableView];
    
    if ([self jhg_needRefreshHeader]) {
        MJRefreshNormalHeader *loadingHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(jhg_refreshHeaderAction)];
        // 隐藏时间
        loadingHeader.lastUpdatedTimeLabel.hidden = YES;
        // 隐藏状态
        // loadingHeader.stateLabel.hidden = YES;
        self.jhg_mainTableView.mj_header = loadingHeader;
    }
    
    if ([self jhg_needRefreshFooter]) {
        self.jhg_mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(jhg_refreshFooterAction)];
    }
}

#pragma mark - style

- (UITableViewStyle)jhg_getTableStyle
{
    return UITableViewStyleGrouped;
}

- (UITableViewCellSeparatorStyle)jhg_getSeparatorStyle
{
    return UITableViewCellSeparatorStyleNone;
}

- (UIColor *)jhg_getSeparatorColor
{
    return [UIColor colorWithWhite:.9 alpha:1];
}

- (UIColor *)jhg_getTableViewBackgroundColor
{
    return [UIColor whiteColor];
}



#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView!=self.jhg_mainTableView) {
        return 1;
    }
    
    if (![self jhg_isTwoDimensionalDataArray]) {
        if (self.jhg_dataArray.count) {
            return 1;
        } else {
            return 0;
        }
    } else {
        return self.jhg_dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![self jhg_isTwoDimensionalDataArray]) {
        
        return self.jhg_dataArray.count;
    } else {
        if (self.jhg_dataArray.count > section) {
            id object = self.jhg_dataArray[section];
            
            if ([object respondsToSelector:@selector(count)]) {
                return [object count];
            }
        }
    }
    return 0;
}

#pragma mark 设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 拿到cellConfig
    JHCellConfig *cellConfig = [self jhg_cellConfigOfIndexPath:indexPath];
    
    // 拿到对应cell并根据模型显示
    UITableViewCell *cell = [cellConfig cellOfCellConfigWithTableView:tableView];
    
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != self.jhg_mainTableView) {
        return tableView.rowHeight;
    }
    
    JHCellConfig *cellConfig = [self jhg_cellConfigOfIndexPath:indexPath];
    cellConfig.tableView = tableView;
    
    return [cellConfig cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != self.jhg_mainTableView) {
        return;
    }
    JHCellConfig *cellConfig = [self jhg_cellConfigOfIndexPath:indexPath];
    if (cellConfig.selectBlock) {
        cellConfig.selectBlock(cellConfig, [tableView cellForRowAtIndexPath:indexPath]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView != self.jhg_mainTableView) {
           return tableView.sectionHeaderHeight;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView != self.jhg_mainTableView) {
           return tableView.sectionFooterHeight;
    }
    return 0.01;
}



#pragma mark - find cellconfig
- (JHCellConfig *)jhg_cellConfigOfIndexPath:(NSIndexPath *)indexPath
{
    if (![self jhg_isTwoDimensionalDataArray]) {
        
        if (self.jhg_dataArray.count > indexPath.row) {
            return self.jhg_dataArray[indexPath.row];
        }
    } else {
        NSInteger section = indexPath.section;
        if (self.jhg_dataArray.count > section) {
            
            id object = self.jhg_dataArray[section];
            
            if ([object isKindOfClass:[NSArray class]] && [object count] > indexPath.row) {
                return object[indexPath.row];
            }
        }
    }
    return nil;
}

- (BOOL)jhg_isTwoDimensionalDataArray
{
    if (self.jhg_dataArray.firstObject && [self.jhg_dataArray.firstObject isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}

#pragma mark -

- (void)addCell:(JHCellConfig *)cellConfig
{
    if (cellConfig) {
        [self.jhg_dataArray addObject:cellConfig];
    }
}
- (void)addSectionCells:(NSArray <__kindof JHCellConfig *> *)cellConfigs
{
    if (cellConfigs) {
        [self.jhg_dataArray addObject:cellConfigs];
    }
}

- (void)clearCells
{
    [self.jhg_dataArray removeAllObjects];
}

#pragma mark - property
- (void)setJhg_dataArray:(NSMutableArray *)dataArray
{
    objc_setAssociatedObject(self, &JHCellConfig_Key_DataArray, dataArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)jhg_dataArray
{
    NSMutableArray *_value = objc_getAssociatedObject(self, &JHCellConfig_Key_DataArray);
    if (!_value) {
        _value = [NSMutableArray array];
        self.jhg_dataArray = _value;
    }
    return _value;
}

- (void)setJhg_mainTableView:(UITableView *)mainTableView
{
    objc_setAssociatedObject(self, &JHCellConfig_Key_MainTableView, mainTableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (UITableView *)jhg_mainTableView
{
    UITableView *_value = objc_getAssociatedObject(self, &JHCellConfig_Key_MainTableView);
    
    if (!_value) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                              style:[self jhg_getTableStyle]];
        _value = tableView;
        self.jhg_mainTableView = _value;
        
        tableView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.separatorStyle = [self jhg_getSeparatorStyle];
        tableView.separatorColor = [self jhg_getSeparatorColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [self jhg_getTableViewBackgroundColor];
        
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    
    return _value;
}


#pragma mark - refresh header footer
- (BOOL)jhg_needRefreshHeader
{
    return NO;
}

- (void)jhg_refreshHeaderAction
{
    
}

- (BOOL)jhg_needRefreshFooter
{
    return NO;
}

- (void)jhg_refreshFooterAction
{
    
}

- (void)jhg_triggerRefreshManully
{
    [self.jhg_mainTableView.mj_header beginRefreshing];
}

- (void)jhg_endHeaderFooterRefreshing
{
    [self.jhg_mainTableView.mj_header endRefreshing];
    if (self.jhg_mainTableView.mj_footer.state != MJRefreshStateNoMoreData) {
        [self.jhg_mainTableView.mj_footer endRefreshing];
    }
}

- (void)jhg_setNoMoreData
{
    self.jhg_mainTableView.mj_footer.state = MJRefreshStateNoMoreData;
}

- (void)jhg_resetNoMoreData
{
    [self.jhg_mainTableView.mj_footer resetNoMoreData];
}


@end
