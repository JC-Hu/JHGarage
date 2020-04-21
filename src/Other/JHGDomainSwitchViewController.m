//
//  JHGDomainSwitchViewController.m
//  JHGarage
//
//  Created by Jason Hu on 2019/5/16.
//  Copyright © 2019 Jason Hu. All rights reserved.
//

#import "JHGDomainSwitchViewController.h"

#import "UIViewController+JHGTable.h"


@interface JHGDomainSwitchViewController ()


@property (nonatomic, strong) NSMutableArray *listDataArray;

@property (nonatomic, strong) UILabel *headerLabel;

@end

@implementation JHGDomainSwitchViewController

+ (JHGDomainSwitchViewController *)show
{
    JHGDomainSwitchViewController *vc = [JHGDomainSwitchViewController new];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nc animated:YES completion:nil];
    
    return vc;
}

#pragma mark - VC life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self jhg_setupJHGTableView];
    self.jhg_mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // "title":"dev","domain":"http://www.baidu.com"
    [self.listDataArray addObjectsFromArray:JHGDomainManager.sharedInstance.domainDataArray];
    
    [self updateDataArray];
    
    self.headerLabel.text = [@"  Current Comain - \n  " stringByAppendingString:JHGDomainManager.sharedInstance.currentDomain];
    self.jhg_mainTableView.tableHeaderView = self.headerLabel;
    
    self.title = @"Domain Switcher";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Custom" style:UIBarButtonItemStylePlain target:self action:@selector(customBarButtonAction:)];
}

#pragma mark - UI

- (void)updateDataArray
{
    [self.jhg_dataArray removeAllObjects];
    
    //
    for (NSDictionary *obj in self.listDataArray) {
        [self.jhg_dataArray addObject:[self listCell:obj]];
    }
}

- (JHCellConfig *)listCell:(NSDictionary *)obj
{
    
    JHCellConfig *cell = [JHCellConfig cellConfigWithCellClass:[UITableViewCell class] dataModel:obj];
    JHWeakSelf
    cell.selectBlock = ^(JHCellConfig *selectCellConfig, UITableViewCell *selectCell) {
        JHStrongSelf
        // 点击事件
        JHGDomainManager.sharedInstance.currentDomain = obj[@"domain"];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - super

#pragma mark 设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 拿到cellConfig
    JHCellConfig *cellConfig = [self jhg_cellConfigOfIndexPath:indexPath];
    
    // 拿到对应cell并根据模型显示
    UITableViewCell *cell = [cellConfig cellOfCellConfigWithTableView:tableView];
    
    NSDictionary *dict = cellConfig.dataModel;
    cell.textLabel.text = dict[@"title"];
    cell.detailTextLabel.text = dict[@"domain"];
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}


#pragma mark - Interaction

- (void)customBarButtonAction:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Input Domain" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = JHGDomainManager.sharedInstance.currentDomain;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = alert.textFields.firstObject;
        if (tf.text.length) {
            JHGDomainManager.sharedInstance.currentDomain = tf.text;
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Get
- (NSMutableArray *)listDataArray
{
    if (!_listDataArray) {
        _listDataArray = [NSMutableArray array];
    }
    return _listDataArray;
}

- (UILabel *)headerLabel
{
    if (!_headerLabel) {
        _headerLabel = [UILabel new];
        _headerLabel.width = kJHScreenWidth;
        _headerLabel.height = 50;
        _headerLabel.adjustsFontSizeToFitWidth = YES;
        _headerLabel.numberOfLines = 3;
    }
    return _headerLabel;
}

#pragma - Set

@end
