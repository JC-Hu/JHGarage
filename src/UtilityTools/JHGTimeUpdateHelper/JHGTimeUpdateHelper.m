//
//  JHGTimeUpdateHelper.m
//  
//
//  Created by JasonHu on 2022/1/13.
//

#import "JHGTimeUpdateHelper.h"

#import "JHGWeakProxy.h"

NSString *const JHGTimeUpdateNotification = @"JHGTimeUpdateNotification";

@interface JHGTimeUpdateHelper ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JHGTimeUpdateHelper
 
MMSingletonImplementation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.updateInterval = .5;
    }
    return self;
}

#pragma mark - Timer
- (void)start
{
    if (self.timer) {
        [self stop];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.updateInterval target:[JHGWeakProxy proxyWithTarget:self] selector:@selector(timerFireAction:) userInfo:nil repeats:YES];
}

- (void)stop
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerFireAction:(id)sender
{
    [NSNotificationCenter.defaultCenter postNotificationName:JHGTimeUpdateNotification object:nil];
}

#pragma mark - Tool

- (NSTimeInterval)currentSystemUpTime
{
    struct timespec sNow;
    clock_gettime(CLOCK_MONOTONIC, &sNow);
    return sNow.tv_sec;
}

- (NSTimeInterval)timeLeftNowWithSystemUpTimeThen:(NSTimeInterval)systemUpTimeThen timeLeftThen:(NSTimeInterval)timeLeftThen
{
    NSTimeInterval timePast = [self currentSystemUpTime] - systemUpTimeThen;
    NSTimeInterval timeLeftNow = timeLeftThen - timePast;
    
    return timeLeftNow;
}

@end
