//
//  JHGDomainManager.m
//  JHGarage
//
//  Created by Jason Hu on 2019/5/16.
//  Copyright © 2019 Jason Hu. All rights reserved.
//

#import "JHGDomainManager.h"


@implementation JHGDomainManager

@synthesize currentDomain = _currentDomain;

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

- (void)setCurrentDomain:(NSString *)currentDomain
{
    if (currentDomain != _currentDomain) {
        _currentDomain = currentDomain;
    }
    [[NSUserDefaults standardUserDefaults] setObject:currentDomain forKey:[self userDefaultKey]];
}

- (NSString *)currentDomain
{
    if (!_currentDomain.length && self.domainDataArray.count) {
        _currentDomain = [[NSUserDefaults standardUserDefaults] objectForKey:[self userDefaultKey]];
        if (_currentDomain.length) {
            return _currentDomain;
        }
        return [self.domainDataArray.firstObject objectForKey:@"domain"];
    }
    return _currentDomain;
}

- (NSString *)userDefaultKey
{
    return [[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"] stringByAppendingString: @"JHGDomainManager"] stringByAppendingString:@"currentDomain"];
}



@end
