//
//  JHGSimpleTableHandler.h
//  CommonPartnerAppiOS
//
//  Created by hlzd on 2022/12/19.
//  Copyright © 2022 Hualu Zhida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHCellConfig.h"
#import "JHGBlankCell.h"
#import "JHGSeparatorCell.h"
#import <MJRefresh/MJRefresh.h>

@interface JHGSimpleTableHandler : NSObject <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_mainTableView;
}


@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) IBOutlet UITableView *mainTableView;

- (void)setupJHGTableView;

// use only one of the two methods below in one vc, dont mix
- (void)jhg_addCell:(JHCellConfig *)cellConfig;
- (void)jhg_addSectionCells:(NSArray <__kindof JHCellConfig *> *)cellConfigs;
// removeAllObjects of dataArray
- (void)jhg_clearCells;

- (JHCellConfig *)cellConfigOfIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForCellConfig:(JHCellConfig *)cellConfig;
- (UITableViewCell *)cellForCellConfig:(JHCellConfig *)cellConfig;

- (BOOL)reloadRowForCellConfig:(JHCellConfig *)cellConfig withRowAnimation:(UITableViewRowAnimation)animation;

- (JHCellConfig *)blankCellWithHeight:(CGFloat)height;
- (JHCellConfig *)clearCellWithHeight:(CGFloat)height;
- (JHCellConfig *)separatorCellWithInset:(CGFloat)inset color:(UIColor *)color;
- (JHCellConfig *)separatorCellWithLeftInset:(CGFloat)leftInset rightInset:(CGFloat)rightInset height:(CGFloat)height color:(UIColor *)color;

// to rewrite
- (UITableViewStyle)getTableStyle;
- (UITableViewCellSeparatorStyle)getSeparatorStyle;
- (UIColor *)getSeparatorColor;
- (UIColor *)getTableViewBackgroundColor;

#pragma mark - refresh header footer

- (BOOL)jhg_needRefreshHeader;
- (void)jhg_refreshHeaderAction;
- (BOOL)jhg_needRefreshFooter;
- (void)jhg_refreshFooterAction;
- (void)jhg_triggerRefreshManully;
- (void)jhg_endHeaderFooterRefreshing;
- (void)jhg_setNoMoreData;
- (void)jhg_resetNoMoreData;

#pragma mark - pagination
- (NSInteger)jhg_firstPageCount; // to rewrite, 第一页的页码值，默认1

@property (nonatomic, assign) NSInteger jhg_pageSize;
@property (nonatomic, assign) NSInteger jhg_pageCount; //pageCount为下一次请求时的页码

#pragma mark - general list
@property (nonatomic, strong) NSMutableArray *jhg_modelArray;

- (void)jhg_setupModelArray:(NSMutableArray *)modelArray withNewListArray:(NSArray *)newListArray;
- (void)jhg_resetListAndPage;

@end

