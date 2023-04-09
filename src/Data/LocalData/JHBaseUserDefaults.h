#import <Foundation/Foundation.h>

@interface JHBaseUserDefaults : NSObject

+ (instancetype)sharedManager;

- (void)removeAll;

- (void)saveWithDict:(NSDictionary *)dict;

@end
