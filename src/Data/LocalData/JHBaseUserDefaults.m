#import "JHBaseUserDefaults.h"
#import <objc/runtime.h>

@implementation JHBaseUserDefaults

static JHBaseUserDefaults *userDefaults = nil;

+ (instancetype)sharedManager {
    Class selfClass = [self class];
    // 从类中获取对象
    id instance = objc_getAssociatedObject(selfClass, @"sharedInstance");
    @synchronized (self) {
        if (!instance) {
            // 不存在，创建对象
            instance = [[super allocWithZone:NULL] init];
            // 给类绑定对象
            objc_setAssociatedObject(selfClass, @"sharedInstance", instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return userDefaults;
}

- (NSString *)userDefaultKeyForProperty:(NSString *)propertyName
{
    // bundleId + className + propertyName
    
    return [[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"] stringByAppendingString: NSStringFromClass(self.class)] stringByAppendingString:propertyName];
}

- (id)init {
    if (self = [super init]) {
        NSMutableArray *properties = [self getProperties];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        for (int i = 0; i < properties.count; i++) {
            
            NSString *key = [self userDefaultKeyForProperty:properties[i]];
            
            void (^setMethodBlock)(id, id) = ^(id info, id object) {
                [userDefaults setObject:object forKey:key];
            };
            void (^setBoolMethodBlock)(id, BOOL) = ^(id info, BOOL result) {
                [userDefaults setBool:result forKey:key];
            };
            void (^setIntegerMethodBlock)(id, NSInteger) = ^(id info, NSInteger value) {
                [userDefaults setInteger:value forKey:key];
            };

            id (^getMethodBlock)(id) = ^(id info) {
                return [userDefaults objectForKey:key];
            };
            BOOL (^getBoolMethodBlock)(id) = ^(id info) {
                return [userDefaults boolForKey:key];
            };
            NSInteger (^getIntegerMethodBlock)(id) = ^(id info) {
                return [userDefaults integerForKey:key];
            };

            objc_property_t property  = class_getProperty([self class], [properties[i] UTF8String]);
            NSString *propertyType        = [[NSString alloc] initWithUTF8String:getPropertyType(property)];
            NSString *setterSelString = [NSString stringWithFormat:@"set%@:", [self initialUpperString:properties[i]]];
            SEL setSel = NSSelectorFromString(setterSelString);
            SEL getSel = NSSelectorFromString(properties[i]);
            IMP setImp = nil;
            IMP getImp = nil;
            
            if ([propertyType isEqualToString:@"BOOL"]) {
                setImp = imp_implementationWithBlock(setBoolMethodBlock);
                getImp = imp_implementationWithBlock(getBoolMethodBlock);
            } else if ([propertyType isEqualToString:@"float"] || [propertyType isEqualToString:@"int"] || [propertyType isEqualToString:@"double"] || [propertyType isEqualToString:@"NSInteger"]) {
                setImp = imp_implementationWithBlock(setIntegerMethodBlock);
                getImp = imp_implementationWithBlock(getIntegerMethodBlock);
            } else {
                setImp = imp_implementationWithBlock(setMethodBlock);
                getImp = imp_implementationWithBlock(getMethodBlock);
            }
            
            class_addMethod([self class], setSel, setImp, "v@:*");
            class_addMethod([self class], getSel, getImp, "@@:");
        }
    }
    return self;
}

static const char * getPropertyType(objc_property_t property) {
    const char * type = property_getAttributes(property);
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = attributes[0]; //NSString * typeAttribute = [attributes objectAtIndex:0];
    NSString * propertyType = [typeAttribute substringFromIndex:1];
    const char * rawPropertyType = [propertyType UTF8String];
    
    if (strcmp(rawPropertyType, @encode(float)) == 0) {
        return "float";
    } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
        return "int";
    } else if (strcmp(rawPropertyType, @encode(double)) == 0) {
        return "double";
    } else if (strcmp(rawPropertyType, @encode(BOOL)) == 0) {
        return "BOOL";
    }
//    else {
        return "id";
//    }
//    return "";
}

- (NSMutableArray *)getProperties {
    NSMutableArray *results = [NSMutableArray array];
    unsigned int count;
    objc_property_t *propeties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propeties[i];
        [results addObject:[NSString stringWithUTF8String:property_getName(property)]];
    }
    free(propeties);
    return results;
}

- (NSString *)initialUpperString:(NSString *)str {
    NSString *initial = [[str substringToIndex:1] uppercaseString];
    
    return [NSString stringWithFormat:@"%@%@", initial, [str substringFromIndex:1]];
}

- (void)removeAll {
    NSMutableArray *properties = [self getProperties];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    for (NSString *property in properties) {
        [userDefaults removeObjectForKey:[self userDefaultKeyForProperty:property]];
    }
}

@end
