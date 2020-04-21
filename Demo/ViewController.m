//
//  ViewController.m
//  JHGarage
//
//  Created by Jason Hu on 2018/11/22.
//  Copyright © 2018 Jason Hu. All rights reserved.
//

#import "ViewController.h"

#import "JHGarage.h"

#import "JHGDomainSwitchViewController.h"
#import "ListDemoViewController.h"

#import "ZTBaseRequestItem.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    NSLog(@"1");
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"2");
    
    [JHGDomainManager.sharedInstance addDomainWithTitle:@"测试环境" domain:@"http://39.104.17.18:8080"];
    [JHGDomainManager.sharedInstance addDomainWithTitle:@"正式环境" domain:@"https://www.zhengtiancy.com"];
    JHGDomainManager.sharedInstance.currentDomain = @"https://www.zhengtiancy.com";
    
}

- (void)sendRequest {
    ZTBaseRequestItem *item = [ZTBaseRequestItem itemWithUrl:@"/api/v3.0/ec/goods/query" params:@{} success:^(NSDictionary *jsonDict, ZTBaseResponseModel *response, ZTBaseRequestItem *ztItem) {
        
    } failure:^(NSDictionary *jsonDict, NSError *error, ZTBaseRequestItem *ztItem) {
        
    }];
    
    [item sendRequest];
}

- (void)showDomainSwitcher {
    
    [JHGDomainSwitchViewController show];
    
}

- (IBAction)buttonAction:(id)sender {
    
//    id good = @"";
//    [good setValue:@1 forKey:@"123"];
    
    
    //
//    [self showDomainSwitcher];
    
    ListDemoViewController *vc = [ListDemoViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    //
    [self sendRequest];
    
}

- (void)dealloc
{
    NSLog(@"123hhh");
}

@end
