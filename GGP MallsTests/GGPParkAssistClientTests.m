//
//  GGPParkAssistClientTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/12/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkAssistClient.h"
#import "NSString+GGPAdditions.h"

@interface GGPParkAssistClient (Testing)

+ (NSString *)signatureWithSecret:(NSString *)secret deviceId:(NSString *)deviceId andSiteName:(NSString *)siteName;
+ (NSString *)signatureWithSecret:(NSString *)secret deviceId:(NSString *)deviceId plate:(NSString *)plate andSiteName:(NSString *)siteName;

@end

@interface GGPParkAssistClientTests : XCTestCase

@end

@implementation GGPParkAssistClientTests

- (void)testSignatureWithPlate {
    NSString *expected = [@"secretdevice=device123,plate=plate123,site=site123" ggp_md5Hash];
    
    NSString *actual = [GGPParkAssistClient signatureWithSecret:@"secret" deviceId:@"device123" plate:@"plate123" andSiteName:@"site123"];
    
    XCTAssertEqualObjects(expected, actual);
}

- (void)testSignatureWithoutPlate {
    NSString *expected = [@"secretdevice=device123,site=site123" ggp_md5Hash];
    
    NSString *actual = [GGPParkAssistClient signatureWithSecret:@"secret" deviceId:@"device123" andSiteName:@"site123"];
    
    XCTAssertEqualObjects(expected, actual);
}

- (void)testRetrieveThumbnailURLForUUID {
    GGPParkAssistClient *client = [GGPParkAssistClient new];
    GGPParkingSite *site = [GGPParkingSite new];
    site.siteName = @"thesite";
    site.secret = @"supersecret";
    
    NSString *thumbnailUUID = @"abc123";
    NSString *deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSString *expectedSignature = [GGPParkAssistClient signatureWithSecret:site.secret deviceId:deviceId andSiteName:site.siteName];
    
    NSString *expected = [NSString stringWithFormat:@"https://insights.parkassist.com/find_your_car/thumbnails/%@.jpg?device=%@&signature=%@&site=%@", thumbnailUUID, deviceId, expectedSignature, site.siteName];
    NSString *actual = [client retrieveThumbnailURLForUUID:thumbnailUUID andSite:site].absoluteString;
    
    XCTAssertEqualObjects(expected, actual);
}

- (void)testRetrieveMapURLForMapName {
    GGPParkAssistClient *client = [GGPParkAssistClient new];
    GGPParkingSite *site = [GGPParkingSite new];
    site.siteName = @"thesite";
    site.secret = @"supersecret";
    
    NSString *mapName = @"level1Map";
    NSString *deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSString *expectedSignature = [GGPParkAssistClient signatureWithSecret:site.secret deviceId:deviceId andSiteName:site.siteName];
    
    NSString *expected = [NSString stringWithFormat:@"https://insights.parkassist.com/find_your_car/maps/%@.png?device=%@&signature=%@&site=%@", mapName, deviceId, expectedSignature, site.siteName];
    NSString *actual = [client retrieveMapURLForMapName:mapName andSite:site].absoluteString;
    
    XCTAssertEqualObjects(expected, actual);
}

@end
