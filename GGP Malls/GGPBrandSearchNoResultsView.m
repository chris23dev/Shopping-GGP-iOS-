//
//  GGPBrandSearchNoResultsView.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPBrandSearchNoResultsView.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPBrandSearchNoResultsView ()

@property (weak, nonatomic) IBOutlet UILabel *noResultsHeading;
@property (weak, nonatomic) IBOutlet UILabel *noResultsLabel;

@end

@implementation GGPBrandSearchNoResultsView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:@"GGPBrandSearchNoResultsView" owner:self options:nil].firstObject;
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor ggp_extraLightGray];
    
    self.noResultsHeading.numberOfLines = 0;
    self.noResultsHeading.textAlignment = NSTextAlignmentCenter;
    self.noResultsHeading.font = [UIFont ggp_boldWithSize:16];
    self.noResultsHeading.text = [@"FILTER_BRANDS_RESULTS_DISCLAIMER_HEADING" ggp_toLocalized];
    
    self.noResultsLabel.numberOfLines = 0;
    self.noResultsLabel.textAlignment = NSTextAlignmentCenter;
    self.noResultsLabel.font = [UIFont ggp_regularWithSize:16];
    self.noResultsLabel.text = [@"FILTER_BRANDS_RESULTS_DISCLAIMER" ggp_toLocalized];
}

@end
