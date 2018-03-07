//
//  GGPEventsNoResultsView.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPEventsNoResultsView.h"
#import "GGPMallManager.h"
#import "GGPMall.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"

@interface GGPEventsNoResultsView ()

@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *subHeadingLabel;

@end

@implementation GGPEventsNoResultsView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:@"GGPEventsNoResultsView" owner:self options:nil].firstObject;
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headingLabel.text = [NSString stringWithFormat:[@"EVENTS_NO_RESULTS_HEADING" ggp_toLocalized], [GGPMallManager shared].selectedMall.name];
    self.headingLabel.textColor = [UIColor ggp_darkGray];
    self.headingLabel.font = [UIFont ggp_mediumWithSize:16];
    
    self.subHeadingLabel.text = [@"EVENTS_NO_RESULTS_SUB_HEADING" ggp_toLocalized];
    self.subHeadingLabel.textColor = [UIColor ggp_darkGray];
    self.subHeadingLabel.font = [UIFont ggp_lightWithSize:16];
}

@end
