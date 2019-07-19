#import <Foundation/Foundation.h>

@interface JHBaseUserDefaults : NSObject

+ (instancetype)sharedManager;

- (void)removeAll;

@end
