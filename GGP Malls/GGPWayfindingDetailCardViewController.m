//
//  GGPWayfindingDetailCardViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJmapViewcontroller+Levels.h"
#import "GGPJMapViewController+Wayfinding.h"
#import "GGPTenant.h"
#import "GGPWayfindingDetailCardViewController.h"
#import "GGPWayfindingFloor.h"
#import "GGPWayfindingRouteDetailViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIImage+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <JMap/JMap.h>

static NSString *const kMoverType = @"mover";

@interface GGPWayfindingDetailCardViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundContainer;
@property (weak, nonatomic) IBOutlet UIView *iconContainer;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *actionIconLabel;
@property (weak, nonatomic) IBOutlet UIImageView *instructionImageView;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIView *separator;

@property (assign, nonatomic) NSInteger currentFloorOrder;

@end

@implementation GGPWayfindingDetailCardViewController

static const double kShadowRadius = 4.0;
static const double kShadowOpacity = 0.75;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)configureWithWayfindingFloor:(GGPWayfindingFloor *)wayfindingFloor {
    self.currentFloorOrder = wayfindingFloor.order;
    [self configureWithInstruction:wayfindingFloor.textDirections.lastObject];
    [self configurePreviousButtonForWayfindingFloor:wayfindingFloor];
}

- (void)configureControls {
    self.view.backgroundColor = [UIColor clearColor];
    [self.backgroundContainer ggp_addShadowWithRadius:kShadowRadius andOpacity:kShadowOpacity];
    
    [self configureNextButton];
    [self configureInstructionLabel];
}

- (void)configureNextButton {
    self.iconContainer.backgroundColor = [UIColor ggp_blue];
    self.iconContainer.layer.cornerRadius = self.iconContainer.frame.size.width/2;
    self.iconImageView.image = [UIImage imageNamed:@"ggp_wayfinding_arrow_next"];
    self.iconImageView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextButtonTapped)];
    [self.iconContainer addGestureRecognizer:tapRecognizer];
    
    self.actionIconLabel.textColor = [UIColor ggp_blue];
    self.actionIconLabel.font = [UIFont ggp_mediumWithSize:10];
    self.actionIconLabel.text = [@"WAYFINDING_NEXT_STEP" ggp_toLocalized];
}

- (void)configureInstructionLabel {
    self.instructionLabel.font = [UIFont ggp_regularWithSize:14];
    self.instructionLabel.textColor = [UIColor ggp_darkGray];
}

- (void)configureWithInstruction:(JMapTextDirectionInstruction *)instruction {
    self.instructionLabel.text = instruction.output;
    self.instructionImageView.image = [self isMoverInstruction:instruction] ? [UIImage ggp_imageForJmapMoverType:instruction.moverType] : [UIImage imageNamed:@"ggp_wayfinding_gray_pin"];
    [self configureNextButtonAsVisible:[self isMoverInstruction:instruction]];
}

- (void)configureNextButtonAsVisible:(BOOL)shouldShowNextButton {
    self.iconContainer.hidden = !shouldShowNextButton;
    self.actionIconLabel.hidden = !shouldShowNextButton;
}

- (void)configurePreviousButtonForWayfindingFloor:(GGPWayfindingFloor *)wayfindingFloor {
    if ([self isStartingFloor:wayfindingFloor]) {
        [self.previousButton ggp_collapseHorizontally];
        self.separator.hidden = YES;
    } else {
        [self.previousButton ggp_expandHorizontally];
        self.separator.hidden = NO;
    }
}

- (IBAction)previousButtonTapped:(id)sender {
    GGPWayfindingFloor *previousFloor = [[GGPJMapManager shared].mapViewController wayfindingFloorWithOrder:self.currentFloorOrder - 1];
    [[GGPJMapManager shared].mapViewController moveToFloor:previousFloor.jmapFloor];
    [self configureWithWayfindingFloor:previousFloor];
}

- (void)nextButtonTapped {
    GGPWayfindingFloor *nextFloor = [[GGPJMapManager shared].mapViewController wayfindingFloorWithOrder:self.currentFloorOrder + 1];
    [[GGPJMapManager shared].mapViewController moveToFloor:nextFloor.jmapFloor];
    [self configureWithWayfindingFloor:nextFloor];
}

- (BOOL)isStartingFloor:(GGPWayfindingFloor *)wayfindingFloor {
    return wayfindingFloor.order == 0;
}

- (BOOL)isMoverInstruction:(JMapTextDirectionInstruction *)instruction {
    return [instruction.type isEqualToString:kMoverType];
}

@end
