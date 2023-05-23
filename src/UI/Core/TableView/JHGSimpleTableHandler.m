//
//  JHGSimpleTableHandler.m
//  CommonPartnerAppiOS
//
//  Created by hlzd on 2022/12/19.
//  Copyright © 2022 Hualu Zhida. All rights reserved.
//

#import "JHGSimpleTableHandler.h"

@implementation JHGSimpleTableHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
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
    return UIColor.whiteColor;
}

- (JHCellConfig *)blankCellWithHeight:(CGFloat)height
{
    JHGBlankCellModel *model = [JHGBlankCellModel new];
    model.height = height;
    model.color = [self getTableViewBackgroundColor];
    
    JHCellConfig *cell = [JHCellConfig cellConfigWithCellClass:[JHGBlankCell class] dataModel:model];
    return cell;
}

- (JHCellConfig *)clearCellWithHeight:(CGFloat)height
{
    JHGBlankCellModel *model = [JHGBlankCellModel new];
    model.height = height;
    model.color = UIColor.clearColor;
    
    JHCellConfig *cell = [JHCellConfig cellConfigWithCellClass:[JHGBlankCell class] dataModel:model];
    return cell;
}

- (JHCellConfig *)separatorCellWithInset:(CGFloat)inset color:(UIColor *)color
{
    return [self separatorCellWithLeftInset:inset rightInset:inset height:1.0/UIScreen.mainScreen.scale color:color];
}

- (JHCellConfig *)separatorCellWithLeftInset:(CGFloat)leftInset rightInset:(CGFloat)rightInset height:(CGFloat)height color:(UIColor *)color
{
    JHGSeparatorCellModel *model = [JHGSeparatorCellModel new];
    model.height = height;
    model.leftInset = leftInset;
    model.rightInset = rightInset;
    model.color = color;
    
    JHCellConfig *cell = [JHCellConfig cellConfigWithCellClass:[JHGSeparatorCell class] dataModel:model];
    return cell;
}

// ============

- (void)setupJHGTableView
{
    if (self.mainTableView) {
        
    }
//    [self.view addSubview:self.mainTableView];
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
    
//    if (self.adjustTableLayout) {
//        [self.mainTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.mas_equalTo(0);
//            make.top.mas_equalTo(self.mas_topLayoutGuide);
//        }];
//        if (@available(iOS 11.0, *)) {
//            self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        }else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
//    }
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView != self.mainTableView) {
        return 1;
    }
    
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
    if (tableView != self.mainTableView) {
        return tableView.rowHeight;
    }

    JHCellConfig *cellConfig = [self cellConfigOfIndexPath:indexPath];
    cellConfig.tableView = tableView;
    
    return [cellConfig cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != self.mainTableView) {
        return;
    }

    JHCellConfig *cellConfig = [self cellConfigOfIndexPath:indexPath];
    if (cellConfig.selectBlock) {
        cellConfig.selectBlock(cellConfig, [tableView cellForRowAtIndexPath:indexPath]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView != self.mainTableView) {
        return tableView.sectionHeaderHeight;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView != self.mainTableView) {
        return tableView.sectionFooterHeight;
    }
    return 0.01;
}

#pragma mark -
- (void)jhg_addCell:(JHCellConfig *)cellConfig
{
    if (cellConfig) {
        [self.dataArray addObject:cellConfig];
    }
}
- (void)jhg_addSectionCells:(NSArray <__kindof JHCellConfig *> *)cellConfigs
{
    if (cellConfigs) {
        [self.dataArray addObject:cellConfigs];
    }
}

- (void)jhg_clearCells
{
    [self.dataArray removeAllObjects];
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

- (NSIndexPath *)indexPathForCellConfig:(JHCellConfig *)cellConfig
{
    if (![self isTwoDimensionalDataArray]) {
        NSUInteger result = [self.dataArray indexOfObject:cellConfig];
        if (result == NSNotFound) {
            return nil;
        }
        return [NSIndexPath indexPathForRow:result inSection:0];
    } else {
        // 暂不支持
        return nil;
    }
}

- (UITableViewCell *)cellForCellConfig:(JHCellConfig *)cellConfig
{
    NSIndexPath *indexPath = [self indexPathForCellConfig:cellConfig];
    
    if (!indexPath) {
        return nil;
    }
    return [self.mainTableView cellForRowAtIndexPath:indexPath];
}

- (BOOL)isTwoDimensionalDataArray
{
    if (self.dataArray.firstObject && [self.dataArray.firstObject isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)reloadRowForCellConfig:(JHCellConfig *)cellConfig withRowAnimation:(UITableViewRowAnimation)animation
{
    NSIndexPath *indexPath = [self indexPathForCellConfig:cellConfig];
    if (indexPath) {
        [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:UIScreen.mainScreen.bounds
                                                              style:[self getTableStyle]];
        _mainTableView = tableView;
        
        tableView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.separatorStyle = [self getSeparatorStyle];
        tableView.separatorColor = [self getSeparatorColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [self getTableViewBackgroundColor];
        
        tableView.estimatedRowHeight = 44;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    
    return _mainTableView;
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
    if (self.mainTableView.mj_footer.state != MJRefreshStateNoMoreData) {
        [self.mainTableView.mj_footer endRefreshing];
    }
}

- (void)setNoMoreData
{
    self.mainTableView.mj_footer.state = MJRefreshStateNoMoreData;
}

- (void)resetNoMoreData
{
    [self.mainTableView.mj_footer resetNoMoreData];
}


#pragma mark - pagination
- (NSInteger)jhg_firstPageCount
{
    return 1;
}



#pragma mark - general list
- (void)jhg_setupModelArray:(NSMutableArray *)modelArray withNewListArray:(NSArray *)newListArray
{
    // 处理主列表业务数据，分页与空白页逻辑
    if (modelArray) {
        self.jhg_modelArray = modelArray;
    }
    
    if (newListArray) {
        [self.jhg_modelArray addObjectsFromArray:newListArray];
    }
    
    if (newListArray.count < self.jhg_pageSize) {
        // nomore data
        [self setNoMoreData];
    } else {
        self.jhg_pageCount++;
    }
    
    if (self.jhg_modelArray.count == 0) {
        // Blank
//        [self showBlankViewForState:JHBlankContentEmpty];
//    } else {
//        [self hideBlankView];
    }
}

// 重制页码刷新
- (void)jhg_resetListAndPage
{
    self.jhg_pageCount = [self jhg_firstPageCount];
    [self.jhg_modelArray removeAllObjects];
    [self resetNoMoreData];
}


- (NSMutableArray *)jhg_modelArray
{
    if (!_jhg_modelArray) {
        _jhg_modelArray = [NSMutableArray array];
    }
    return _jhg_modelArray;
}


@end
