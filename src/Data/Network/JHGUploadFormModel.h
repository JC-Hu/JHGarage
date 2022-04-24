//

#import <Foundation/Foundation.h>


@interface JHGUploadFormModel : NSObject

@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, copy) NSString *mimeType;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *name;

+ (instancetype)formModelWithData:(NSData *)fileData
                         mimeType:(NSString *)mimeType
                         fileName:(NSString *)fileName
                             name:(NSString *)name;


@end

