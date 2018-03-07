//
//  GGPParkingReminderCardViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/17/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingReminderCardViewController.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "GGPParkingReminder.h"

@interface GGPParkingReminderCardViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *textViewContainerView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *clearLabel;
@property (weak, nonatomic) IBOutlet UIButton *placePinButton;

@end

@implementation GGPParkingReminderCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (NSString *)noteText {
    return self.textView.text;
}

- (void)setNoteText:(NSString *)noteText {
    self.textView.text = noteText;
}

- (void)configureControls {
    self.titleLabel.font = [UIFont ggp_regularWithSize:16];
    self.descriptionLabel.font = [UIFont ggp_regularWithSize:14];
    
    self.clearLabel.textColor = [UIColor ggp_blue];
    self.clearLabel.font = [UIFont ggp_mediumWithSize:14];
    self.clearLabel.text = [@"PARKING_REMINDER_CLEAR_BUTTON" ggp_toLocalized];
    [self.clearLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearReminderTapped)]];
    
    [self.placePinButton setTitle:[@"PARKING_REMINDER_CARD_PLACE_PIN_BUTTON" ggp_toLocalized] forState:UIControlStateNormal];
    [self.placePinButton ggp_styleAsDarkActionButton];
    self.placePinButton.titleLabel.font = [UIFont ggp_regularWithSize:20];
    
    [self configureTextView];
    [self configureForDefaultState];
}

- (void)configureTextView {
    [self.textViewContainerView ggp_addBorderWithWidth:1 andColor:[UIColor ggp_lightGray]];
    self.textView.text = [@"PARKING_REMINDER_CARD_ADD_NOTE" ggp_toLocalized];
    self.textView.font = [UIFont ggp_regularWithSize:14];
    self.textView.textColor = [UIColor ggp_darkGray];
    self.textView.delegate = self;
}

- (void)configureForDefaultState {
    self.titleLabel.text = [@"PARKING_REMINDER_CARD_SAVE_YOUR_SPOT" ggp_toLocalized];
    self.descriptionLabel.text = [@"PARKING_REMINDER_CARD_PLACE_PIN_INSTRUCTIONS" ggp_toLocalized];
    CGFloat labelHeight = [self.descriptionLabel sizeThatFits:CGSizeMake(self.descriptionLabel.frame.size.width, CGFLOAT_MAX)].height;
    [self.descriptionLabel ggp_expandVerticallyWithHeight:labelHeight];
    
    self.placePinButton.hidden = NO;
    self.textViewContainerView.hidden = YES;
    self.clearLabel.hidden = YES;
}

- (void)configureForLocationSaved {
    self.titleLabel.text = [@"PARKING_REMINDER_CARD_SPOT_SAVED" ggp_toLocalized];
    self.descriptionLabel.text = [@"PARKING_REMINDER_CARD_MOVE_MARKER" ggp_toLocalized];
    [self.descriptionLabel sizeToFit];
    CGFloat labelHeight = [self.descriptionLabel sizeThatFits:CGSizeMake(self.descriptionLabel.frame.size.width, CGFLOAT_MAX)].height;
    [self.descriptionLabel ggp_expandVerticallyWithHeight:labelHeight];
    self.textView.text = [@"PARKING_REMINDER_CARD_ADD_NOTE" ggp_toLocalized];
    
    self.placePinButton.hidden = YES;
    self.textViewContainerView.hidden = NO;
    self.clearLabel.hidden = NO;
}

- (void)configureForExistingLocationWithNote:(NSString *)note {
    self.titleLabel.text = [@"PARKING_REMINDER_CARD_EXISTING_SPOT" ggp_toLocalized];
    [self.descriptionLabel ggp_collapseVertically];
    self.textView.text = note;
    
    self.placePinButton.hidden = YES;
    self.textViewContainerView.hidden = NO;
    self.clearLabel.hidden = NO;
}

- (void)clearReminderTapped {
    [self.view endEditing:YES];
    self.textView.text = [@"PARKING_REMINDER_CARD_ADD_NOTE" ggp_toLocalized];
    [self.cardDelegate clearReminderTapped];
}

- (IBAction)placePinButtonTapped:(id)sender {
    [self.cardDelegate placePinTapped];
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:[@"PARKING_REMINDER_CARD_ADD_NOTE" ggp_toLocalized]]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = [@"PARKING_REMINDER_CARD_ADD_NOTE" ggp_toLocalized];
    }
    
    GGPParkingReminder *reminder = [GGPParkingReminder retrieveSavedReminder];
    reminder.note = textView.text;
    [reminder saveToUserDefaults];
    
    if (reminder.note.length > 0) {
        [[GGPAnalytics shared] trackAction:GGPAnalyticsActionParkingReminderAddNote withData:nil];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
    }
    return YES;
}

@end
