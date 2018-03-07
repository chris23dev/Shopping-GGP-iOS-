//
//  GGPParkingReminderCardViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/17/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingReminderCardViewController.h"
#import "NSString+GGPAdditions.h"

@interface GGPParkingReminderCardViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *textViewContainerView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *clearLabel;

- (void)textViewDidBeginEditing:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end

@interface GGPParkingReminderCardViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPParkingReminderCardViewController *cardViewController;

@end

@implementation GGPParkingReminderCardViewControllerTests

- (void)setUp {
    [super setUp];
    self.cardViewController = [GGPParkingReminderCardViewController new];
    [self.cardViewController view];
}

- (void)tearDown {
    self.cardViewController = nil;
    [super tearDown];
}

- (void)testConfigureForLocationSaved {
    [self.cardViewController configureForLocationSaved];
    
    XCTAssertEqualObjects(self.cardViewController.titleLabel.text, [@"PARKING_REMINDER_CARD_SPOT_SAVED" ggp_toLocalized]);
    XCTAssertEqualObjects(self.cardViewController.descriptionLabel.text, [@"PARKING_REMINDER_CARD_MOVE_MARKER" ggp_toLocalized]);
    XCTAssertEqualObjects(self.cardViewController.clearLabel.text, [@"PARKING_REMINDER_CLEAR_BUTTON" ggp_toLocalized]);
}

- (void)testTextViewDidBeginEditing {
    self.cardViewController.textView.text = [@"PARKING_REMINDER_CARD_ADD_NOTE" ggp_toLocalized];
    [self.cardViewController textViewDidBeginEditing:self.cardViewController.textView];
    XCTAssertEqualObjects(self.cardViewController.textView.text, @"");
    
    self.cardViewController.textView.text = @"mock text";
    [self.cardViewController textViewDidBeginEditing:self.cardViewController.textView];
    XCTAssertEqualObjects(self.cardViewController.textView.text, @"mock text");
}

- (void)testTextViewDidEndEditing {
    self.cardViewController.textView.text = @"";
    [self.cardViewController textViewDidEndEditing:self.cardViewController.textView];
    XCTAssertEqualObjects(self.cardViewController.textView.text, [@"PARKING_REMINDER_CARD_ADD_NOTE" ggp_toLocalized]);
    
    self.cardViewController.textView.text = @"mock text";
    [self.cardViewController textViewDidEndEditing:self.cardViewController.textView];
    XCTAssertEqualObjects(self.cardViewController.textView.text, @"mock text");
}

- (void)testTextViewShouldChangeTextInRangeWithReturnCharacter {
    id mockView = OCMPartialMock(self.cardViewController.view);
    OCMExpect([mockView endEditing:YES]);
    
    [self.cardViewController textView:nil shouldChangeTextInRange:NSMakeRange(0, 1) replacementText:@"\n"];
    
    OCMVerifyAll(mockView);
}

@end
