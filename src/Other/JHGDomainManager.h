//
//  JHGDomainManager.h
//  JHGarage
//
//  Created by Jason Hu on 2019/5/16.
//  Copyright © 2019 Jason Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JHMarcoTools.h"


@interface JHGDomainManager : NSObject

MMSingletonInterface

@property (nonatomic, strong) NSString *currentDomain;

@property (nonatomic, strong) NSMutableArray *domainDataArray;
// "title":"dev","domain":"http://39.104.17.18:8080"

- (void)addDomainWithTitle:(nonnull NSString *)title domain:(nonnull NSString *)domain;

@end

