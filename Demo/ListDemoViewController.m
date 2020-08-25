//
//  ListDemoViewController.m
//  JHGarage
//
//  Created by Jason Hu on 2020/2/16.
//  Copyright © 2020 Jason Hu. All rights reserved.
//

#import "ListDemoViewController.h"

#import "JHGarage.h"

@interface ListDemoViewController ()

@end

@implementation ListDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self jhg_setupJHGTableView];
    
    [self updateDataArray];
}

- (void)updateDataArray
{
    [self clearCells];
    
    //
    for (int i = 0; i < 20; i++) {
        NSDictionary *obj = @{
            @"index": @(i)
        };
        [self addCell:[self listCell:obj]];
    }
}

- (JHCellConfig *)listCell:(NSDictionary *)obj
{
    
    JHCellConfig *cell = [JHCellConfig cellConfigWithCellClass:[UITableViewCell class] dataModel:obj];
    JHWeakSelf
    cell.selectBlock = ^(JHCellConfig *selectCellConfig, UITableViewCell *selectCell) {
        JHStrongSelf
        // 点击事件
        
        [self showToast:[obj[@"index"] stringValue]];
    };
    
    cell.constantHeight = 60;
    
    return cell;
}

- (JHCellConfig *)blankCellWithHeight:(CGFloat)height
{
    JHGBlankCellModel *model = [JHGBlankCellModel new];
    model.height = height;
    model.color = self.jhg_mainTableView.backgroundColor;
    
    JHCellConfig *cell = [JHCellConfig cellConfigWithCellClass:[JHGBlankCell class] dataModel:model];
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 拿到cellConfig
    JHCellConfig *cellConfig = [self jhg_cellConfigOfIndexPath:indexPath];
    
    // 拿到对应cell并根据模型显示
    UITableViewCell *cell = [cellConfig cellOfCellConfigWithTableView:tableView];
    
    NSDictionary *dict = cellConfig.dataModel;
    cell.textLabel.text = [dict[@"index"] stringValue];
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
