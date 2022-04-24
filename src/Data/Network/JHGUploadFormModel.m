//
//

#import "JHGUploadFormModel.h"

@implementation JHGUploadFormModel

+ (instancetype)formModelWithData:(NSData *)fileData
                         mimeType:(NSString *)mimeType
                         fileName:(NSString *)fileName
                             name:(NSString *)name
{
    JHGUploadFormModel *model = [JHGUploadFormModel new];
    model.fileData = fileData;
    model.mimeType = mimeType;
    model.fileName = fileName;
    model.name = name;
    return model;
}


@end
