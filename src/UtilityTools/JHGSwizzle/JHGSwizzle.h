// JRSwizzle renamed


#import <Foundation/Foundation.h>

@interface NSObject (JHGSwizzle)

+ (BOOL)jhg_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_;
+ (BOOL)jhg_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_;


/**
 ```
 __block NSInvocation *invocation = nil;
 invocation = [self jhg_swizzleMethod:@selector(initWithCoder:) withBlock:^(id obj, NSCoder *coder) {
 NSLog(@"before %@, coder %@", obj, coder);

 [invocation setArgument:&coder atIndex:2];
 [invocation invokeWithTarget:obj];

 id ret = nil;
 [invocation getReturnValue:&ret];

 NSLog(@"after %@, coder %@", obj, coder);

 return ret;
 } error:nil];
 ```
 */
+ (NSInvocation*)jhg_swizzleMethod:(SEL)origSel withBlock:(id)block error:(NSError**)error;

/**
 ```
 __block NSInvocation *classInvocation = nil;
 classInvocation = [self jhg_swizzleClassMethod:@selector(test) withBlock:^() {
 NSLog(@"before");

 [classInvocation invoke];

 NSLog(@"after");
 } error:nil];
 ```
 */
+ (NSInvocation*)jhg_swizzleClassMethod:(SEL)origSel withBlock:(id)block error:(NSError**)error;

@end
