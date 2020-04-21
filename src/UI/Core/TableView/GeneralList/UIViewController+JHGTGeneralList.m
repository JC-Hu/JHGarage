//
//  UIViewController+JHGTGeneralList.m
//  JHGarage
//
//  Created by Jason Hu on 2019/1/25.
//  Copyright © 2019 Jason Hu. All rights reserved.
//

#import "UIViewController+JHGTGeneralList.h"

#import <objc/runtime.h>
#import "JHGSwizzle.h"

static NSString * const JHCellConfig_Key_PageSize;
static NSString * const JHCellConfig_Key_PageCount;

static NSString * const JHCellConfig_Key_ModelArray;


@implementation UIViewController (JHGTGeneralList)

#pragma mark - pagination
- (NSInteger)jhg_firstPageCount
{
    return 1;
}


- (void)setJhg_pageSize:(NSInteger)jhg_pageSize
{
    objc_setAssociatedObject(self, &JHCellConfig_Key_PageSize, @(jhg_pageSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSInteger)jhg_pageSize
{
    NSInteger _value = [objc_getAssociatedObject(self, &JHCellConfig_Key_PageSize) integerValue];
    return _value;
}

- (void)setJhg_pageCount:(NSInteger)jhg_pageCount
{
    objc_setAssociatedObject(self, &JHCellConfig_Key_PageCount, @(jhg_pageCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSInteger)jhg_pageCount
{
    NSInteger _value = [objc_getAssociatedObject(self, &JHCellConfig_Key_PageCount) integerValue];
    return _value;
    
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
        [self jhg_setNoMoreData];
    } else {
        self.jhg_pageCount++;
    }
    
    if (self.jhg_modelArray.count == 0) {
        // Blank
        [self showBlankViewForState:JHBlankContentEmpty];
    } else {
        [self hideBlankView];
    }
}

// 重制页码刷新
- (void)jhg_resetListAndPage
{
    [self.jhg_dataArray removeAllObjects];
    [self.jhg_mainTableView reloadData];
    self.jhg_pageCount = [self jhg_firstPageCount];
    [self.jhg_modelArray removeAllObjects];
    [self jhg_resetNoMoreData];
}

- (void)setJhg_modelArray:(NSMutableArray *)jhg_modelArray
{
    objc_setAssociatedObject(self, &JHCellConfig_Key_ModelArray, jhg_modelArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSMutableArray *)jhg_modelArray
{
    NSMutableArray *_value = objc_getAssociatedObject(self, &JHCellConfig_Key_ModelArray);
    if (!_value) {
        _value = [NSMutableArray array];
        self.jhg_modelArray = _value;
    }
    return _value;
}

@end
