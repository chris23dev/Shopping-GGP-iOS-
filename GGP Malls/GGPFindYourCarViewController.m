//
//  GGPFindYourCarViewController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 9/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFindYourCarViewController.h"
#import "GGPCarLocationsTableViewController.h"
#import "GGPParkAssistClient.h"
#import "GGPMallRepository.h"
#import "GGPParkingCarLocation.h"
#import "GGPParkingSite.h"
#import "GGPParkingGarage.h"
#import "GGPParkingLevel.h"
#import "GGPSpinner.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static NSInteger const kMaxCharacterLength = 10;
static NSInteger const kMinSearchTextLength = 3;

@interface GGPFindYourCarViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *plateTextField;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;

@property (strong, nonatomic) GGPParkingSite *site;
@property (strong, nonatomic) NSCharacterSet *invalidCharacters;

@end

@implementation GGPFindYourCarViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = [@"FIND_MY_CAR_TITLE" ggp_toLocalized];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableCharacterSet *allowedCharacters = [NSMutableCharacterSet alphanumericCharacterSet];
    [allowedCharacters addCharactersInString:@" "];
    self.invalidCharacters = allowedCharacters.invertedSet;
    
    [self configureControls];
    [self retrieveParkAssistSite];
}

- (void)configureControls {
    self.headerLabel.font = [UIFont ggp_lightWithSize:26];
    self.headerLabel.textColor = [UIColor ggp_darkGray];
    self.headerLabel.text = [@"FIND_MY_CAR_HEADER" ggp_toLocalized];
    
    self.disclaimerLabel.font = [UIFont ggp_regularWithSize:12];
    self.disclaimerLabel.textColor = [UIColor ggp_manateeGray];
    self.disclaimerLabel.text = [@"FIND_MY_CAR_LENGTH_REQUIREMENT" ggp_toLocalized];
    
    self.plateTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"FIND_MY_CAR_ENTER_LICENSE_PLATE" ggp_toLocalized] attributes:@{ NSForegroundColorAttributeName: [UIColor ggp_pastelGray] }];
    self.plateTextField.font = [UIFont ggp_regularWithSize:16];
    self.plateTextField.textColor = [UIColor ggp_darkGray];
    self.plateTextField.layer.borderColor = [UIColor ggp_pastelGray].CGColor;
    self.plateTextField.layer.borderWidth = 1;
    self.plateTextField.layer.cornerRadius = 4;
    self.plateTextField.delegate = self;
}

- (void)retrieveParkAssistSite {
    [GGPSpinner showForView:self.view];
    self.plateTextField.userInteractionEnabled = NO;
    [GGPMallRepository fetchParkingSiteWithCompletion:^(GGPParkingSite *site) {
        [GGPSpinner hideForView:self.view];
        if (site) {
            self.plateTextField.userInteractionEnabled = YES;
            self.site = site;
        } else {
            [self ggp_displayAlertWithTitle:nil andMessage:[@"ALERT_GENERIC_ERROR_MESSAGE" ggp_toLocalized]];
        }
    }];
}

- (void)validateFieldText:(NSString *)fieldText {
    NSString *searchText = [fieldText stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (searchText.length >= kMinSearchTextLength) {
        [self performSearch:searchText];
    } else {
        [self displayErrorMessage:[@"FIND_MY_CAR_LENGTH_REQUIREMENT" ggp_toLocalized]];
    }
}

- (void)performSearch:(NSString *)searchText {
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionParkingFindMyCar withData:nil];
    
    [[GGPParkAssistClient shared] retrieveCarLocationsForPlate:searchText site:self.site andCompletion:^(NSArray *carLocations) {
        NSArray *validCarLocations = [self validCarLocationsFromCarLocations:carLocations];
        if (validCarLocations.count > 0) {
            GGPCarLocationsTableViewController *carLocationTableViewController = [[GGPCarLocationsTableViewController alloc] initWithSite:self.site searchText:searchText andCarLocations:validCarLocations];
            [self.navigationController pushViewController:carLocationTableViewController animated:YES];
        } else {
            [self displayErrorMessage:[NSString stringWithFormat:[@"FIND_MY_CAR_NO_RESULTS" ggp_toLocalized], self.plateTextField.text]];
        }
    }];
}

- (NSArray *)validCarLocationsFromCarLocations:(NSArray *)carLocations {
    return [carLocations ggp_arrayWithFilter:^BOOL(GGPParkingCarLocation *carLocation) {
        return carLocation.zoneName != nil;
    }];
}

- (void)displayErrorMessage:(NSString *)message {
    self.disclaimerLabel.text = message;
    self.disclaimerLabel.textColor = [UIColor ggp_darkRed];
    
    self.plateTextField.textColor = [UIColor ggp_darkRed];
    self.plateTextField.layer.borderColor = [UIColor ggp_darkRed].CGColor;
    self.plateTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"FIND_MY_CAR_ENTER_LICENSE_PLATE" ggp_toLocalized] attributes:@{ NSForegroundColorAttributeName: [UIColor ggp_darkRed] }];
}

- (void)clearErrorMessage {
    self.disclaimerLabel.textColor = [UIColor ggp_manateeGray];
    self.disclaimerLabel.text = [@"FIND_MY_CAR_LENGTH_REQUIREMENT" ggp_toLocalized];
    
    self.plateTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"FIND_MY_CAR_ENTER_LICENSE_PLATE" ggp_toLocalized] attributes:@{ NSForegroundColorAttributeName: [UIColor ggp_pastelGray] }];
    self.plateTextField.textColor = [UIColor ggp_darkGray];
    self.plateTextField.layer.borderColor = [UIColor ggp_pastelGray].CGColor;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.plateTextField resignFirstResponder];
    [self clearErrorMessage];
    [self validateFieldText:self.plateTextField.text];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self clearErrorMessage];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length + range.location > self.plateTextField.text.length) {
        return NO;
    }
    
    NSInteger newLength = self.plateTextField.text.length + string.length - range.length;
    
    return newLength <= kMaxCharacterLength && [self hasValidCharacters:string];
}

- (BOOL)hasValidCharacters:(NSString *)string {
    return [string rangeOfCharacterFromSet:self.invalidCharacters].location == NSNotFound;
}

@end
