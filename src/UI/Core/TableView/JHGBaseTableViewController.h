//
//  Created by JasonHu on 2018/4/21.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//

#import "JHGBaseViewController.h"

#import "JHCellConfig.h"
#import "UIView+JHGShortcut.h"
#import "JHGBaseCell.h"
#import "JHGBlankCell.h"

#import "MJRefresh.h"

@interface JHGBaseTableViewController : JHGBaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;


@property (nonatomic, strong) IBOutlet UITableView *mainTableView;

- (JHCellConfig *)cellConfigOfIndexPath:(NSIndexPath *)indexPath;

// to rewrite
- (UITableViewStyle)getTableStyle;
- (UITableViewCellSeparatorStyle)getSeparatorStyle;
- (UIColor *)getSeparatorColor;
- (UIColor *)getTableViewBackgroundColor;


#pragma mark - refresh header footer
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageCount;

- (BOOL)needRefreshHeader;
- (void)refreshHeaderAction;
- (BOOL)needRefreshFooter;
- (void)refreshFooterAction;
- (void)triggerRefreshManully;
- (void)endHeaderFooterRefreshing;


@end