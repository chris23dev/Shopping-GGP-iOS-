//
//  GGPFindYourCarViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFindYourCarViewController.h"
#import "GGPParkingCarLocation.h"
#import "GGPParkingSite.h"
#import "GGPParkingGarage.h"
#import "GGPParkingLevel.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPFindYourCarViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *plateTextField;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;

@property (strong, nonatomic) GGPParkingSite *site;
@property (strong, nonatomic) NSCharacterSet *invalidCharacters;

- (NSArray *)validCarLocationsFromCarLocations:(NSArray *)carLocations;
- (void)validateFieldText:(NSString *)fieldText;
- (void)performSearch:(NSString *)searchText;
- (void)displayErrorMessage:(NSString *)message;
- (BOOL)isValidLengthForRange:(NSRange)range andString:(NSString *)string;
- (BOOL)hasValidCharacters:(NSString *)string;

@end

@interface GGPFindYourCarViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPFindYourCarViewController *viewController;

@end

@implementation GGPFindYourCarViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [GGPFindYourCarViewController new];
    [self.viewController view];
}

- (void)tearDown {
    self.viewController = nil;
    [super tearDown];
}

- (void)testValidCarLocations {
    id mockCarLocation1 = OCMPartialMock([GGPParkingCarLocation new]);
    id mockCarLocation2 = OCMPartialMock([GGPParkingCarLocation new]);
    
    [OCMStub([mockCarLocation1 zoneName]) andReturn:nil];
    [OCMStub([mockCarLocation2 zoneName]) andReturn:@"name"];
    
    NSArray *result = [self.viewController validCarLocationsFromCarLocations:@[mockCarLocation1, mockCarLocation2]];
    
    XCTAssertEqual(result.count, 1);
    XCTAssertEqual(result.firstObject, mockCarLocation2);
}

- (void)testValidateFieldTextTrimsSpaces {
    id mockController = OCMPartialMock(self.viewController);
    OCMExpect([mockController performSearch:@"abc"]);
    
    [self.viewController validateFieldText:@" a  b  c "];
    
    OCMVerifyAll(mockController);
}

- (void)testValidateFieldTextInvalidLength {
    id mockController = OCMPartialMock(self.viewController);
    OCMExpect([mockController displayErrorMessage:[@"FIND_MY_CAR_LENGTH_REQUIREMENT" ggp_toLocalized]]);
    
    [self.viewController validateFieldText:@" a  b   "];
    
    OCMVerifyAll(mockController);
}

- (void)testHasValidCharacters {
    XCTAssertTrue([self.viewController hasValidCharacters:@"ab1"]);
    XCTAssertTrue([self.viewController hasValidCharacters:@"a  b1"]);
    XCTAssertTrue([self.viewController hasValidCharacters:@"111"]);
    XCTAssertFalse([self.viewController hasValidCharacters:@"ab+"]);
    XCTAssertFalse([self.viewController hasValidCharacters:@"@@@"]);
}

- (void)testMaxLength {
    self.viewController.plateTextField.text = @"";
    XCTAssertTrue([self.viewController textField:[UITextField new]
                   shouldChangeCharactersInRange:NSMakeRange(0, 0)
                               replacementString:@"abcde12345"]);
    
    self.viewController.plateTextField.text = @"abc";
    XCTAssertTrue([self.viewController textField:[UITextField new]
                   shouldChangeCharactersInRange:NSMakeRange(3, 0)
                               replacementString:@"a"]);
    
    self.viewController.plateTextField.text = @"abcde12345";
    XCTAssertFalse([self.viewController textField:[UITextField new]
                   shouldChangeCharactersInRange:NSMakeRange(9, 0)
                               replacementString:@"a"]);
    
    self.viewController.plateTextField.text = @"abcde";
    XCTAssertFalse([self.viewController textField:[UITextField new]
                   shouldChangeCharactersInRange:NSMakeRange(6, 0)
                               replacementString:@"123456"]);
}

@end
