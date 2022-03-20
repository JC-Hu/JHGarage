//
//  JHGTimeUpdateHelper.h
//  
//
//  Created by JasonHu on 2022/1/13.
//


/*
 倒计时定时器工具
 
 如何使用：
 1. Appdelegate中 调用[JHGTimeUpdateHelper.sharedInstance start];
 2. 请求数据成功后，存下当时系统启动时间和接口返回剩余秒数
    model.systemUpTimeThen = [JHGTimeUpdateHelper.sharedInstance currentSystemUpTime];
    model.timeLeftThen = timeLeft;
 3. 监听通知JHGTimeUpdateNotification，并在回调中更新UI
 
    timeLeftNow = [JHGTimeUpdateHelper.sharedInstance timeLeftNowWithSystemUpTimeThen:model.systemUpTimeThen timeLeftThen:model.timeLeftThen];
 
 
 */

#import <Foundation/Foundation.h>
#import "JHMacroTools.h"

extern NSString *const JHGTimeUpdateNotification;

@interface JHGTimeUpdateHelper : NSObject

MMSingletonInterface


@property (nonatomic, assign) NSTimeInterval updateInterval;

#pragma mark - Timer
- (void)start;
- (void)stop;

#pragma mark - Tool

- (NSTimeInterval)currentSystemUpTime;


/// 计算剩余秒数
/// @param systemUpTimeThen 某时刻的系统开机时间
/// @param timeLeftThen 某时刻的剩余秒数
- (NSTimeInterval)timeLeftNowWithSystemUpTimeThen:(NSTimeInterval)systemUpTimeThen timeLeftThen:(NSTimeInterval)timeLeftThen;

@end

