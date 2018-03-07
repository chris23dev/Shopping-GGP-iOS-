//
//  GGPPreferencesToggleViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPPreferencesToggleDelegate.h"
#import <UIKit/UIKit.h>

@class GGPFormField;
@class GGPCheckboxButton;

@interface GGPPreferencesToggleViewController : UIViewController

@property (weak, nonatomic) id <GGPPreferencesToggleDelegate> toggleDelegate;

@property (weak, nonatomic) IBOutlet GGPCheckboxButton *emailCheckbox;
@property (weak, nonatomic) IBOutlet GGPCheckboxButton *smsCheckbox;

@property (strong, nonatomic, readonly) GGPFormField *smsField;

- (void)configureSMSFieldForState:(BOOL)isOn;

@end
