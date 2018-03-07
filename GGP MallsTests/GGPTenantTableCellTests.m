//
//  GGPTenantTableCellTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/17/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPJMapManager.h"
#import "GGPTenant.h"
#import "GGPTenantTableCell.h"
#import "UIFont+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MGSwipeTableCell/MGSwipeTableCell.h>

@interface GGPTenantTableCellTests : XCTestCase

@property (strong, nonatomic) GGPTenantTableCell *cell;
@property (strong, nonatomic) NSString *mockTenantName;

@end

@interface GGPTenantTableCell (Testing)

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) MGSwipeButton *favoriteButton;
@property (strong, nonatomic) MGSwipeButton *guideMeButton;

- (NSString *)logoUrlForTenant:(GGPTenant *)tenant;
- (NSString *)locationForTenant:(GGPTenant *)tenant;
- (void)configureSwipeButtonsForTenant:(GGPTenant *)tenant;
- (NSString *)imageNameForIsFavorite:(BOOL)isFavorite;

@end

@implementation GGPTenantTableCellTests

- (void)setUp {
    [super setUp];
    self.cell = [[[NSBundle mainBundle] loadNibNamed:@"GGPTenantTableCell" owner:self options:nil] lastObject];
    self.mockTenantName = @"tenant name";
}

- (void)tearDown {
    self.cell = nil;
    self.mockTenantName = nil;
    [super tearDown];
}

- (void)testOutletsInitialized {
    XCTAssertNotNil(self.cell.titleLabel);
    XCTAssertNotNil(self.cell.locationLabel);
    XCTAssertNotNil(self.cell.logoImageView);
}

- (void)testConfigureCellWithTenant {
    UIImageView *mockImageView = OCMPartialMock(self.cell.logoImageView);
    OCMExpect([mockImageView setImageWithURL:OCMOCK_ANY]);
    GGPTenant *mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant name]) andReturn:self.mockTenantName];
    [self.cell configureCellWithTenant:mockTenant];
    XCTAssertEqualObjects(self.cell.titleLabel.text, self.mockTenantName);
    OCMVerify(mockImageView);
    XCTAssertEqualObjects(self.cell.titleLabel.font, [UIFont ggp_boldWithSize:15]);
    XCTAssertEqualObjects(self.cell.locationLabel.textColor, [UIColor blackColor]);
    XCTAssertEqualObjects(self.cell.locationLabel.font, [UIFont ggp_lightWithSize:15]);
}

- (void)testLocationWithParentTenant {
    NSString *parentName = @"Parent Name";
    NSString *expectedLocation = [NSString stringWithFormat:@"Inside %@", parentName];
    GGPTenant *mockParentTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockParentTenant name]) andReturn:parentName];
    
    GGPTenant *tenant = [GGPTenant new];
    tenant.parentTenant = mockParentTenant;
    
    NSString *locationText = [self.cell locationForTenant:tenant];
    XCTAssertEqualObjects(locationText, expectedLocation);
}

- (void)testConfigureSwipeButtonsEmpty {
    id mockAccount = OCMClassMock(GGPAccount.class);
    [OCMStub(ClassMethod([mockAccount isLoggedIn])) andReturnValue:@NO];
    
    id mockJMapManager = OCMPartialMock([GGPJMapManager shared]);
    [OCMStub([mockJMapManager wayfindingAvailableForTenant:OCMOCK_ANY]) andReturnValue:@NO];
    
    [self.cell configureSwipeButtonsForTenant:[GGPTenant new]];
    
    XCTAssertEqual(0, self.cell.rightButtons.count);
    
    [mockAccount stopMocking];
    [mockJMapManager stopMocking];
}

- (void)testConfigureSwipeButtonsOnlyGuideMe {
    id mockAccount = OCMClassMock(GGPAccount.class);
    [OCMStub(ClassMethod([mockAccount isLoggedIn])) andReturnValue:@NO];
    
    id mockJMapManager = OCMPartialMock([GGPJMapManager shared]);
    [OCMStub([mockJMapManager wayfindingAvailableForTenant:OCMOCK_ANY]) andReturnValue:@YES];
    
    [self.cell configureSwipeButtonsForTenant:[GGPTenant new]];
    
    XCTAssertEqual(1, self.cell.rightButtons.count);
    XCTAssertEqual(self.cell.guideMeButton, self.cell.rightButtons[0]);
    
    [mockAccount stopMocking];
    [mockJMapManager stopMocking];
}

- (void)testConfigureSwipeButtonsOnlyFavorite {
    id mockAccount = OCMClassMock(GGPAccount.class);
    [OCMStub(ClassMethod([mockAccount isLoggedIn])) andReturnValue:@YES];
    
    id mockJMapManager = OCMPartialMock([GGPJMapManager shared]);
    [OCMStub([mockJMapManager wayfindingAvailableForTenant:OCMOCK_ANY]) andReturnValue:@NO];
    
    [self.cell configureSwipeButtonsForTenant:[GGPTenant new]];
    
    XCTAssertEqual(1, self.cell.rightButtons.count);
    XCTAssertEqual(self.cell.favoriteButton, self.cell.rightButtons[0]);
    
    [mockAccount stopMocking];
    [mockJMapManager stopMocking];
}

- (void)testConfigureSwipeButtonsGuideMeAndFavorite {
    id mockAccount = OCMClassMock(GGPAccount.class);
    [OCMStub(ClassMethod([mockAccount isLoggedIn])) andReturnValue:@YES];
    
    id mockJMapManager = OCMPartialMock([GGPJMapManager shared]);
    [OCMStub([mockJMapManager wayfindingAvailableForTenant:OCMOCK_ANY]) andReturnValue:@YES];
    
    [self.cell configureSwipeButtonsForTenant:[GGPTenant new]];
    
    XCTAssertEqual(2, self.cell.rightButtons.count);
    XCTAssertEqual(self.cell.favoriteButton, self.cell.rightButtons[0]);
    XCTAssertEqual(self.cell.guideMeButton, self.cell.rightButtons[1]);
    
    [mockAccount stopMocking];
    [mockJMapManager stopMocking];
}

- (void)testImageNameForIsFavorite {
    XCTAssertEqualObjects(@"ggp_choose_favorites_heart_active", [self.cell imageNameForIsFavorite:YES]);
    XCTAssertEqualObjects(@"ggp_choose_favorites_heart_inactive", [self.cell imageNameForIsFavorite:NO]);
}

@end
