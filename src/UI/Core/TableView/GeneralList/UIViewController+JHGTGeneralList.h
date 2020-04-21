//
//  UIViewController+JHGTGeneralList.h
//  JHGarage
//
//  Created by Jason Hu on 2019/1/25.
//  Copyright © 2019 Jason Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+JHGTable.h"
#import "UIViewController+JHGBlankView.h"

@interface UIViewController (JHGTGeneralList)

#pragma mark - pagination
- (NSInteger)jhg_firstPageCount; // to rewrite, 第一页的页码值，默认1

@property (nonatomic, assign) NSInteger jhg_pageSize;
@property (nonatomic, assign) NSInteger jhg_pageCount; //pageCount为下一次请求时的页码

#pragma mark - general list
@property (nonatomic, strong) NSMutableArray *jhg_modelArray;

- (void)jhg_setupModelArray:(NSMutableArray *)modelArray withNewListArray:(NSArray *)newListArray;
- (void)jhg_resetListAndPage;
@end

