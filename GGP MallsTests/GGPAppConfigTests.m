//
//  GGPAppConfigTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/15/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <Mantle/MTLJSONAdapter.h>
#import "GGPAppConfig.h"

@interface GGPAppConfigTests : XCTestCase

@property (strong, nonatomic) GGPAppConfig *appConfig;
@property (strong, nonatomic) NSDictionary *jsonDictionary;

@end

@implementation GGPAppConfigTests

- (void)setUp {
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"appconfig" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.appConfig = (GGPAppConfig *)[MTLJSONAdapter modelOfClass:GGPAppConfig.class fromJSONDictionary:self.jsonDictionary error:nil];
}

- (void)tearDown {
    self.appConfig = nil;
    self.jsonDictionary = nil;
    [super tearDown];
}

- (void)testAppConfigProperties {
    XCTAssertNotNil(self.appConfig);
    XCTAssertEqual(self.appConfig.minIosVersion, self.jsonDictionary[@"minIosVersion"]);
}

@end
