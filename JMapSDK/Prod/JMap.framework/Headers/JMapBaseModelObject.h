

// Bryan: aim to make obsolete


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef __JMapSDK__BaseModelObject__
#define __JMapSDK__BaseModelObject__

@class JMapAPIRequest, JMapAnnotation;

@interface JMapBaseModelObject : NSObject
{
    //JMapAnnotation *_annotation;
}

+ (NSDictionary*)attributeMapDictionary;
+ (NSDictionary*)jsonMapDictionary;
- (NSString *)deserializeObject;

@property (nonatomic, strong) NSString *rawJSON;
@property (nonatomic, copy) NSString *requestURL;
@property (nonatomic, strong) JMapAnnotation *annotation;

@end


#endif /* defined(__JMapSDK__BaseModelObject__) */

