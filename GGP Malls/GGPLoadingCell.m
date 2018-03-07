//
//  GGPLoadingCell.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPLoadingCell.h"

NSString *const GGPLoadingCellId = @"GGPLoadingCell";

@interface GGPLoadingCell ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation GGPLoadingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)startLoading {
    [self.activityIndicator startAnimating];
}

@end
