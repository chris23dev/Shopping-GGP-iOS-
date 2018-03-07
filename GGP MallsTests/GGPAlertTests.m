//
//  GGPAlertTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAlert.h"
#import "GGPAppContainerViewController.h"
#import "NSDate+GGPAdditions.h"
#import <Mantle/MTLJSONAdapter.h>

@interface GGPAlertTests : XCTestCase

@property GGPAlert *alert;
@property NSDictionary *jsonDictionary;

@end

@interface GGPAlert (Testing)

@property NSInteger alertId;
@property NSDate *effectiveEndDateTime;
@property NSString *message;

@end

@implementation GGPAlertTests

- (void)setUp {
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"alert" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.alert = (GGPAlert *)[MTLJSONAdapter modelOfClass:GGPAlert.class fromJSONDictionary:self.jsonDictionary error:nil];
}

- (void)tearDown {
    self.alert = nil;
    self.jsonDictionary = nil;
    [super tearDown];
}

- (void)testAlert {
    XCTAssertNotNil(self.alert);
    XCTAssertNotNil(@(self.alert.alertId));
    XCTAssertNotNil(self.alert.message);
}

@end
