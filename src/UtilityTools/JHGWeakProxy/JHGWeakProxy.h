//
//  JHGWeakProxy.h
//  JHGarage
//
//  Created by Jason Hu on 2022/3/20.
//  Copyright © 2022 Jason Hu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JHGWeakProxy : NSProxy

/**
 The proxy target.
 */
@property (nullable, nonatomic, weak, readonly) id target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
- (instancetype)initWithTarget:(id)target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
+ (instancetype)proxyWithTarget:(id)target;


@end
