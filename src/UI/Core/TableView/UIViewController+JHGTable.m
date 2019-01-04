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

static NSString * const JHCellConfig_Key_PageSize;
static NSString * const JHCellConfig_Key_PageCount;

@implementation UIViewController (JHGTable)
+ (void)load
{
    [self jhg_swizzleMethod:@selector(viewDidLoad) withMethod:@selector(jhgt_viewDidLoad) error:nil];
}

- (void)jhgt_viewDidLoad {
    
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
    
//    self.pageSize = 10;
//    self.pageCount = 1;
    
    [self jhgt_viewDidLoad];

}

#pragma mark -

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

#pragma mark
//- (void)setPageSize:(NSInteger)pageSize
//{
//    objc_setAssociatedObject(self, &JHCellConfig_Key_PageSize, @(pageSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//}
//
//- (NSInteger)pageSize
//{
//    NSInteger _value = [objc_getAssociatedObject(self, &JHCellConfig_Key_PageSize) integerValue];
//    return _value;
//}
//
//- (void)setPageCount:(NSInteger)pageCount
//{
//    objc_setAssociatedObject(self, &JHCellConfig_Key_PageCount, @(pageCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//}
//
//- (NSInteger)pageCount
//{
//    NSInteger _value = [objc_getAssociatedObject(self, &JHCellConfig_Key_PageCount) integerValue];
//    return _value;
//
//}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    objc_setAssociatedObject(self, &JHCellConfig_Key_DataArray, dataArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)dataArray
{
    NSMutableArray *_value = objc_getAssociatedObject(self, &JHCellConfig_Key_DataArray);
    if (!_value) {
        _value = [NSMutableArray array];
        self.dataArray = _value;
    }
    return _value;
}

- (void)setMainTableView:(UITableView *)mainTableView
{
    objc_setAssociatedObject(self, &JHCellConfig_Key_MainTableView, mainTableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (UITableView *)mainTableView
{
    UITableView *_value = objc_getAssociatedObject(self, &JHCellConfig_Key_MainTableView);
    
    if (!_value) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                              style:[self getTableStyle]];
        _value = tableView;
        tableView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.separatorStyle = [self getSeparatorStyle];
        tableView.separatorColor = [self getSeparatorColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [self getTableViewBackgroundColor];
        
        //    if (@available(iOS 11.0, *)) {
        //        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //    }else {
        //        self.automaticallyAdjustsScrollViewInsets = NO;
        //    }
        
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    
    return _value;
}



@end
