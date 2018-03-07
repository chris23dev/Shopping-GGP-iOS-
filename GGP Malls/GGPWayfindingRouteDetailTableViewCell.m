//
//  GGPWayfindingRouteDetailTableViewCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/16/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPWayfindingRouteDetailTableViewCell.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import <JMap/JMap.h>

NSString* const GGPWayfindingRouteDetailTableViewCellReuseIdentifier = @"GGPWayfindingRouteDetailTableViewCellReuseIdentifier";
CGFloat const GGPWayfindingRouteDetailTableViewCellHeight = 80;

@interface GGPWayfindingRouteDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *directionImageView;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (strong, nonatomic) NSDictionary *instructionImageDictionary;

@end

@implementation GGPWayfindingRouteDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureLabel];
    [self configureInstructionImageDictionary];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureLabel {
    self.directionLabel.numberOfLines = 0;
    [self.directionLabel setFont:[UIFont ggp_regularWithSize:14]];
    self.directionLabel.textColor = [UIColor ggp_darkGray];
}

- (void)configureInstructionImageDictionary {
    self.instructionImageDictionary = @{
                                        @"Forward": @"ggp_icon_direction_forward",
                                        @"Slight Left": @"ggp_icon_direction_left",
                                        @"Left UTurn": @"ggp_icon_direction_uturn",
                                        @"Left": @"ggp_icon_direction_left",
                                        @"Slight Right": @"ggp_icon_direction_right",
                                        @"Right": @"ggp_icon_direction_right",
                                        @"Right UTurn": @"ggp_icon_direction_uturn",
                                        @"Down": @"ggp_icon_direction_down",
                                        @"Up": @"ggp_icon_direction_down"
                                        };
}

- (UIImage *)getImageForInstructionDirection:(JMapTextDirectionInstruction *)instruction {
    return [UIImage imageNamed:self.instructionImageDictionary[instruction.direction]];
}

- (void)configureCellWithDirectionInstruction:(JMapTextDirectionInstruction *)instruction {
    self.directionLabel.text = instruction.output;
    self.directionImageView.image = [self getImageForInstructionDirection:instruction];
}

@end
