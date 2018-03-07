//
//  GGPTenantSearchNoResultsView.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenantSearchNoResultsView.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

@interface GGPTenantSearchNoResultsView ()

@property (weak, nonatomic) IBOutlet UILabel *noResultsLabel;

@end

@implementation GGPTenantSearchNoResultsView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:@"GGPTenantSearchNoResultsView" owner:self options:nil].firstObject;
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.noResultsLabel.text = [@"WAYFINDING_NO_RESULTS" ggp_toLocalized];
    self.noResultsLabel.textColor = [UIColor ggp_colorFromHexString:@"bababa"];
    self.noResultsLabel.font = [UIFont ggp_regularWithSize:15];
    self.backgroundColor = [UIColor ggp_extraLightGray];
}

@end
