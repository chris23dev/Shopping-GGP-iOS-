//
//  GGPOnboardingMallLoadingViewController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPBenefitsViewController.h"
#import "GGPMallRepository.h"
#import "GGPOnboardingMallLoadingViewController.h"
#import "GGPSweepstakes.h"
#import "UIImage+GGPAdditions.h"

static NSInteger const kLoadingDisplayDuration = 2;

@interface GGPMallLoadingViewController (Onboarding)

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@interface GGPOnboardingMallLoadingViewController ()

@property (strong, nonatomic) GGPSweepstakes *sweepstakes;

@end

@implementation GGPOnboardingMallLoadingViewController

- (instancetype)init {
    return [super initWithNibName:@"GGPMallLoadingViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureDisplayTimer];
}

- (void)configureDisplayTimer {
    dispatch_group_t group = dispatch_group_create();

    [self fetchSweepstakesWithGroup:group];
    [self startTimerWithGroup:group];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        [self.navigationController pushViewController:[[GGPBenefitsViewController alloc] initWithSweepstakes:self.sweepstakes] animated:YES];
    });
}

- (void)fetchSweepstakesWithGroup:(dispatch_group_t)group {
    dispatch_group_enter(group);

    [GGPMallRepository fetchSweepstakesWithCompletion:^(GGPSweepstakes *sweepstakes) {
        self.sweepstakes = sweepstakes;
        if (self.sweepstakes) {
            [self fetchSweepstakesImageWithGroup:group];
        } else {
            dispatch_group_leave(group);
        }
    }];
}

- (void)fetchSweepstakesImageWithGroup:(dispatch_group_t)group {
    [UIImage ggp_fetchImageWithUrl:[NSURL URLWithString:self.sweepstakes.imageUrl] completion:^(UIImage *image) {
        self.sweepstakes.image = image ? image : [UIImage imageNamed:@"ggp_benefit_sweepstakes_default"];
        dispatch_group_leave(group);
    }];
}

- (void)startTimerWithGroup:(dispatch_group_t)group {
    dispatch_group_enter(group);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kLoadingDisplayDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_group_leave(group);
    });
}

@end
