//
//  JHGDomainManager.m
//  JHGarage
//
//  Created by Jason Hu on 2019/5/16.
//  Copyright © 2019 Jason Hu. All rights reserved.
//

#import "JHGDomainManager.h"


@implementation JHGDomainManager

MMSingletonImplementation

- (void)addDomainWithTitle:(NSString *)title domain:(NSString *)domain
{
    [self.domainDataArray addObject:@{@"title":title, @"domain":domain}];
}



- (NSMutableArray *)domainDataArray
{
    if (!_domainDataArray) {
        _domainDataArray = [NSMutableArray array];
    }
    return _domainDataArray;
}

@end
