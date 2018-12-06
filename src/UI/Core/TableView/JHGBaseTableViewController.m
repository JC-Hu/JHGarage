//
//  Created by JasonHu on 2018/4/21.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//

#import "JHGBaseTableViewController.h"


@interface JHGBaseTableViewController ()

@end

@implementation JHGBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                      style:[self getTableStyle]];
    self.mainTableView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mainTableView.separatorStyle = [self getSeparatorStyle];
    self.mainTableView.separatorColor = [self getSeparatorColor];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [self getTableViewBackgroundColor];
    
//    if (@available(iOS 11.0, *)) {
//        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }

    self.mainTableView.estimatedRowHeight = 0;
    self.mainTableView.estimatedSectionHeaderHeight = 0;
    self.mainTableView.estimatedSectionFooterHeight = 0;

    self.mainTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:self.mainTableView];
    
    
    if ([self needRefreshHeader]) {
        MJRefreshNormalHeader *loadingHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderAction)];
        // 隐藏时间
        loadingHeader.lastUpdatedTimeLabel.hidden = YES;
        // 隐藏状态
        // loadingHeader.stateLabel.hidden = YES;
        self.mainTableView.mj_header = loadingHeader;
    }
    
    if ([self needRefreshFooter]) {
        self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooterAction)];
    }
    
    self.pageSize = 10;
    self.pageCount = 1;
}

- (UITableViewStyle)getTableStyle
{
    return UITableViewStyleGrouped;
}

- (UITableViewCellSeparatorStyle)getSeparatorStyle
{
    return UITableViewCellSeparatorStyleNone;
}

- (UIColor *)getSeparatorColor
{
    return [UIColor colorWithWhite:.9 alpha:1];
}

- (UIColor *)getTableViewBackgroundColor
{
    return [UIColor whiteColor];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (![self isTwoDimensionalDataArray]) {
        if (self.dataArray.count) {
            return 1;
        } else {
            return 0;
        }
    } else {
        return self.dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![self isTwoDimensionalDataArray]) {
        
        return self.dataArray.count;
    } else {
        if (self.dataArray.count > section) {
            id object = self.dataArray[section];
            
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
    JHCellConfig *cellConfig = [self cellConfigOfIndexPath:indexPath];
    
    // 拿到对应cell并根据模型显示
    UITableViewCell *cell = [cellConfig cellOfCellConfigWithTableView:tableView];
    
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHCellConfig *cellConfig = [self cellConfigOfIndexPath:indexPath];
    
    return [cellConfig cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHCellConfig *cellConfig = [self cellConfigOfIndexPath:indexPath];
    if (cellConfig.selectBlock) {
        cellConfig.selectBlock(cellConfig, [tableView cellForRowAtIndexPath:indexPath]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark -
- (JHCellConfig *)cellConfigOfIndexPath:(NSIndexPath *)indexPath
{
    if (![self isTwoDimensionalDataArray]) {
        
        if (self.dataArray.count > indexPath.row) {
            return self.dataArray[indexPath.row];
        }
    } else {
        NSInteger section = indexPath.section;
        if (self.dataArray.count > section) {
            
            id object = self.dataArray[section];
            
            if ([object isKindOfClass:[NSArray class]] && [object count] > indexPath.row) {
                return object[indexPath.row];
            }
        }
    }
    return nil;
}

- (BOOL)isTwoDimensionalDataArray
{
    if (self.dataArray.firstObject && [self.dataArray.firstObject isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}


#pragma mark - refresh header footer
- (BOOL)needRefreshHeader
{
    return NO;
}

- (void)refreshHeaderAction
{
    
}

- (BOOL)needRefreshFooter
{
    return NO;
}

- (void)refreshFooterAction
{
    
}

- (void)triggerRefreshManully
{
    [self.mainTableView.mj_header beginRefreshing];
}

- (void)endHeaderFooterRefreshing
{
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
}

#pragma mark - Lazy Init

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

@end
