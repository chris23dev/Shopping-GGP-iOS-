//
//  GGPClient+ParkAssist.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 9/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkAssistClient.h"
#import "GGPParkingCarLocation.h"
#import "GGPParkingZone.h"
#import "NSString+GGPAdditions.h"
#import "NSURL+GGPAdditions.h"

static NSString *const kBaseURL = @"https://insights.parkassist.com/find_your_car/";
static NSString *const kDeviceParam = @"device";
static NSString *const kPlateParam = @"plate";
static NSString *const kSignatureParam = @"signature";
static NSString *const kSiteParam = @"site";

@implementation GGPParkAssistClient

+ (instancetype)shared {
    static GGPParkAssistClient *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[GGPParkAssistClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    });
    
    return instance;
}

- (void)retrieveCarLocationsForPlate:(NSString *)plate site:(GGPParkingSite *)site andCompletion:(void(^)(NSArray *carLocations))completion {
    NSString *deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSString *signature = [GGPParkAssistClient signatureWithSecret:site.secret deviceId:deviceId plate:plate andSiteName:site.siteName];
    
    NSDictionary *params = @{
                             kDeviceParam: deviceId,
                             kPlateParam: plate,
                             kSignatureParam: signature,
                             kSiteParam: site.siteName
                             };

    [self GET:@"search.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:NSArray.class]) {
            completion([MTLJSONAdapter modelsOfClass:GGPParkingCarLocation.class fromJSONArray: responseObject error:nil]);
        } else {
            completion(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GGPLogError(@"Error retrieving car locations for plate: %@. %@", plate, error.localizedDescription);
        completion(nil);
    }];
}

- (void)retrieveZonesForSite:(GGPParkingSite *)site andCompletion:(void(^)(NSArray *zones))completion {
    NSString *deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSString *signature = [GGPParkAssistClient signatureWithSecret:site.secret deviceId:deviceId andSiteName:site.siteName];
    
    NSDictionary *params = @{
                             kDeviceParam: deviceId,
                             kSignatureParam: signature,
                             kSiteParam: site.siteName
                             };
    
    [self GET:@"zones.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:NSArray.class]) {
            completion([MTLJSONAdapter modelsOfClass:GGPParkingZone.class fromJSONArray: responseObject error:nil]);
        } else {
            completion(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GGPLogError(@"Error retrieving zones: %@", error.localizedDescription);
        completion(nil);
    }];
}

- (NSURL *)retrieveThumbnailURLForUUID:(NSString *)uuid andSite:(GGPParkingSite *)site {
    NSString *deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSString *signature = [GGPParkAssistClient signatureWithSecret:site.secret deviceId:deviceId andSiteName:site.siteName];
    NSString *request = [NSString stringWithFormat:@"%@thumbnails/%@.jpg", kBaseURL, uuid];
    
    NSDictionary *params = @{
                             kDeviceParam: deviceId,
                             kSignatureParam: signature,
                             kSiteParam: site.siteName
                             };
    
    return [NSURL ggp_urlWithString:request andParameters:params];
}

- (NSURL *)retrieveMapURLForMapName:(NSString *)mapName andSite:(GGPParkingSite *)site {
    NSString *deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSString *signature = [GGPParkAssistClient signatureWithSecret:site.secret deviceId:deviceId andSiteName:site.siteName];
    NSString *request = [NSString stringWithFormat:@"%@maps/%@.png", kBaseURL, mapName];
    
    NSDictionary *params = @{
                             kDeviceParam: deviceId,
                             kSignatureParam: signature,
                             kSiteParam: site.siteName
                             };
    
    return [NSURL ggp_urlWithString:request andParameters:params];
}

+ (NSString *)signatureWithSecret:(NSString *)secret deviceId:(NSString *)deviceId plate:(NSString *)plate andSiteName:(NSString *)siteName {
    NSString *signature = [NSString stringWithFormat:@"%@%@=%@,%@=%@,%@=%@", secret, kDeviceParam, deviceId, kPlateParam, plate, kSiteParam, siteName];
    return [signature ggp_md5Hash];
}


+ (NSString *)signatureWithSecret:(NSString *)secret deviceId:(NSString *)deviceId andSiteName:(NSString *)siteName {
    NSString *signature = [NSString stringWithFormat:@"%@%@=%@,%@=%@", secret, kDeviceParam, deviceId, kSiteParam, siteName];
    return [signature ggp_md5Hash];
}

@end
