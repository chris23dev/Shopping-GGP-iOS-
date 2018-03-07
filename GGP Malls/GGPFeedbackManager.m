//
//  GGPFeedbackManager.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAppConfig.h"
#import "GGPClient.h"
#import "GGPFeedbackManager.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPModalViewController.h"
#import "GGPWebViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static NSString *const kFeedbackActionCountKey = @"GGPFeedbackActionCountKey";
static NSString *const kFeedbackEligibleKey = @"GGPFeedbackEligibleKey";
static NSString *const kFeedBackUrlParamHeader = @"&custom_var=";
static NSInteger const kDefaultActionsRequired = 25;

@interface GGPFeedbackManager ()

@property (strong, nonatomic) UIViewController *presenter;
@property (strong, nonatomic) UIAlertAction *initialYesAction;
@property (strong, nonatomic) UIAlertAction *initialNoAction;
@property (strong, nonatomic) UIAlertAction *giveFeedbackAction;
@property (strong, nonatomic) UIAlertAction *rateAction;
@property (strong, nonatomic) UIAlertAction *remindAction;
@property (strong, nonatomic) UIAlertAction *noThanksAction;
@property (assign, nonatomic) NSInteger actionsRequiredForFeedbackAlert;

@end

@implementation GGPFeedbackManager

+ (instancetype)shared {
    static GGPFeedbackManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [GGPFeedbackManager new];
        [self requestAppConfig];
    });
    
    return instance;
}

+ (void)requestAppConfig {
    [[GGPClient sharedInstance] fetchAppConfigWithCompletion:^(GGPAppConfig *appConfig, NSError *error) {
        BOOL hasAppConfig = !error && appConfig;
        [GGPFeedbackManager shared].actionsRequiredForFeedbackAlert = hasAppConfig ? appConfig.iosFeedbackActionCount : kDefaultActionsRequired;
    }];
}

+ (void)configureWithPresenter:(UIViewController *)presenter {
    [GGPFeedbackManager shared].presenter = presenter;
}

+ (void)trackAction {
    if ([GGPFeedbackManager isEligibleForFeedbackAlert]) {
        NSInteger updatedActionCount = [GGPFeedbackManager feedbackActionCount] + 1;
        [GGPFeedbackManager updateFeedbackActionCount:updatedActionCount];

        if (updatedActionCount == [GGPFeedbackManager shared].actionsRequiredForFeedbackAlert) {
            [[GGPFeedbackManager shared] displayInitialFeedbackAlert];
        }
    }
}

+ (void)resetActionCount {
    [GGPFeedbackManager updateFeedbackActionCount:0];
}

+ (NSInteger)feedbackActionCount {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kFeedbackActionCountKey];
}

+ (void)updateFeedbackActionCount:(NSInteger)count {
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:kFeedbackActionCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isEligibleForFeedbackAlert {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kFeedbackEligibleKey] == nil) {
        [GGPFeedbackManager updateIsEligibleForFeedBackAlert:YES];
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFeedbackEligibleKey];
}

+ (void)updateIsEligibleForFeedBackAlert:(BOOL)isEligible {
    [[NSUserDefaults standardUserDefaults] setBool:isEligible forKey:kFeedbackEligibleKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)displayInitialFeedbackAlert {
    NSArray *actions = @[self.initialYesAction, self.initialNoAction];
    [self.presenter ggp_displayAlertWithTitle:[@"FEEDBACK_INITIAL_QUESTION_TITLE" ggp_toLocalized] message:nil andActions:actions];
}

- (void)displayNegativeFeedbackAlert {
    NSArray *actions = @[self.giveFeedbackAction, self.noThanksAction];
    [self.presenter ggp_displayAlertWithTitle:[@"FEEDBACK_NEGATIVE_TITLE" ggp_toLocalized] message:[@"FEEDBACK_NEGATIVE_MESSAGE" ggp_toLocalized] andActions:actions];
}

- (void)displayPositiveFeedbackAlert {
    NSArray *actions = @[self.rateAction, self.remindAction, self.noThanksAction];
    [self.presenter ggp_displayAlertWithTitle:[@"FEEDBACK_POSITIVE_TITLE" ggp_toLocalized] message:[@"FEEDBACK_POSITIVE_MESSAGE" ggp_toLocalized] andActions:actions];
}

- (UIAlertAction *)initialYesAction {
    return [UIAlertAction actionWithTitle:[@"FEEDBACK_BUTTON_YES" ggp_toLocalized] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self displayPositiveFeedbackAlert];
    }];
}

- (UIAlertAction *)initialNoAction {
    return [UIAlertAction actionWithTitle:[@"FEEDBACK_BUTTON_NO" ggp_toLocalized] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self displayNegativeFeedbackAlert];
    }];
}

- (UIAlertAction *)giveFeedbackAction {
    return [UIAlertAction actionWithTitle:[@"FEEDBACK_BUTTON_GIVE_FEEDBACK" ggp_toLocalized] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [GGPFeedbackManager updateIsEligibleForFeedBackAlert:NO];
        [self presentFeedbackScreen];
    }];
}

- (UIAlertAction *)rateAction {
    return [UIAlertAction actionWithTitle:[@"FEEDBACK_BUTTON_RATE_NOW" ggp_toLocalized] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [GGPFeedbackManager updateIsEligibleForFeedBackAlert:NO];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"APP_STORE_LINK" ggp_toLocalized]]];
    }];
}

- (UIAlertAction *)remindAction {
    return [UIAlertAction actionWithTitle:[@"FEEDBACK_BUTTON_REMIND" ggp_toLocalized] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [GGPFeedbackManager updateFeedbackActionCount:0];
    }];
}

- (UIAlertAction *)noThanksAction {
    return [UIAlertAction actionWithTitle:[@"FEEDBACK_BUTTON_NO_THANKS" ggp_toLocalized] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [GGPFeedbackManager updateIsEligibleForFeedBackAlert:NO];
    }];
}

- (void)presentFeedbackScreen {
    NSString *urlAllowedMallName = [[GGPMallManager shared].selectedMall.name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *feedbackUrl = [NSString stringWithFormat:@"%@%@%@", [@"FEEDBACK_URL" ggp_toLocalized], kFeedBackUrlParamHeader, urlAllowedMallName];
    GGPWebViewController *webViewController = [[GGPWebViewController alloc] initWithTitle:[@"FEEDBACK_TITLE" ggp_toLocalized] urlString:feedbackUrl andAnalyticsConst:GGPAnalyticsScreenFeedback];
    
    
    [self.presenter presentViewController:[[GGPModalViewController alloc] initWithRootViewController:webViewController andOnClose:^{
        [self.presenter dismissViewControllerAnimated:YES completion:nil];
    }] animated:YES completion:nil];
}

@end
