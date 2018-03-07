//
//  GGPLevelCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJMapViewController+Wayfinding.h"
#import "GGPLevelCell.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <JMap/JMap.h>

NSString *const GGPLevelCellReuseIdentifier = @"GGPLevelCellReuseIdentifier";
CGFloat const GGPLevelCellHeight = 35;
NSInteger const GGPLevelCellMaxStringLength = 6;
static NSInteger const kDescriptionLabelPadding = 17;

@interface GGPLevelCell ()

@property (weak, nonatomic) IBOutlet UIView *filterCountView;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *topBorder;
@property (weak, nonatomic) IBOutlet UIView *rightBorder;
@property (weak, nonatomic) IBOutlet UIView *bottomBorder;
@property (weak, nonatomic) IBOutlet UIView *leftBorder;

@property (assign, nonatomic) CGFloat cellWidth;
@property (strong, nonatomic) JMapFloor *floor;
@property (assign, nonatomic) NSString *filterText;
@property (assign, nonatomic) BOOL isActive;

@end

@implementation GGPLevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureCell];
}

- (void)configureCell {
    self.label.font = [GGPLevelCell levelFont];
    self.topBorder.backgroundColor = [UIColor blackColor];
    self.rightBorder.backgroundColor = [UIColor blackColor];
    self.bottomBorder.backgroundColor = [UIColor blackColor];
    self.leftBorder.backgroundColor = [UIColor blackColor];
    
    self.filterCountView.backgroundColor = [UIColor ggp_blue];
    [self.filterCountView ggp_addBorderRadius:self.filterCountView.frame.size.width / 2];
    self.filterLabel.textColor = [UIColor whiteColor];
    self.filterLabel.textAlignment = NSTextAlignmentCenter;
    self.filterLabel.font = [UIFont ggp_regularWithSize:10];
}

- (void)configureCellWithFloor:(JMapFloor *)floor filterText:(NSString *)filterText isActive:(BOOL)isActive andIsBottomCell:(BOOL)isBottomCell {
    self.floor = floor;
    self.label.text = [self levelDescriptionFromFloor:floor];
    self.filterText = filterText;
    self.isActive = isActive;
    self.bottomBorder.hidden = !isBottomCell;
    
    [self configureFilterLabel];
    [self configureIconForFloor];
    
    if (isActive) {
        [self setActiveStyle];
    } else {
        [self setInactiveStyle];
    }
}

- (void)configureFilterLabel {
    self.filterCountView.hidden = !self.filterText;
    self.filterLabel.hidden = !self.filterText;
    self.filterLabel.text = self.filterText;
}

+ (UIFont *)levelFont {
    return [UIFont ggp_regularWithSize:14];
}

+ (CGFloat)determineCellWidthForDescriptionLength:(NSInteger)length {
    NSString *text = [@"" stringByPaddingToLength:length withString:@"X" startingAtIndex:0];
    CGSize size = [text sizeWithAttributes: @{ NSFontAttributeName: [GGPLevelCell levelFont] }];
    return ceilf(size.width) + kDescriptionLabelPadding;
}

- (NSString *)levelDescriptionFromFloor:(JMapFloor *)floor {
    return [floor.description substringToIndex:MIN(GGPLevelCellMaxStringLength, floor.description.length)];
}

- (BOOL)floorIsStartFloor {
    JMapFloor *startFloor = [[GGPJMapManager shared].mapViewController wayfindingStartFloor];
    return self.floor.mapId.integerValue == startFloor.mapId.integerValue;
}

- (BOOL)floorIsEndFloor {
    JMapFloor *endFloor = [[GGPJMapManager shared].mapViewController wayfindingEndFloor];
    return self.floor.mapId.integerValue == endFloor.mapId.integerValue;
}

- (BOOL)shouldShowStartIcon {
    return [self floorIsStartFloor] && !self.isActive;
}

- (BOOL)shouldShowEndIcon {
    return [self floorIsEndFloor] && !self.isActive && ![self floorIsStartFloor];
}

- (void)configureIconForFloor {
    self.imageView.hidden = NO;
    if ([self shouldShowStartIcon]) {
        self.imageView.image = [UIImage imageNamed:@"ggp_icon_level_start_pin"];
    } else if ([self shouldShowEndIcon]) {
        self.imageView.image = [UIImage imageNamed:@"ggp_icon_level_end_pin"];
    } else {
        self.imageView.hidden = YES;
    }
}

- (void)setActiveStyle {
    self.label.backgroundColor = [UIColor ggp_blue];
    self.label.textColor = [UIColor whiteColor];
    self.filterCountView.hidden = YES;
}

- (void)setInactiveStyle {
    self.filterCountView.hidden = !self.filterText;
    self.label.backgroundColor = [UIColor ggp_colorFromHexString:@"#FEFEFE" andAlpha:0.85];
    self.label.textColor = [UIColor ggp_colorFromHexString:@"#333333"];
}

@end
