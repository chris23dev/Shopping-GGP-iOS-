//
//  GGPNavigationTitleView.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPNavigationTitleView.h"
#import "UIFont+GGPAdditions.h"

@interface GGPNavigationTitleView ()

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation GGPNavigationTitleView

- (instancetype)initWithImage:(UIImage *)image andText:(NSString *)text {
    self = [[NSBundle mainBundle] loadNibNamed:@"GGPNavigationTitleView" owner:self options:nil].firstObject;
    if (self) {
        self.titleImageView.image = image;
        self.titleLabel.text = text;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont ggp_boldWithSize:16];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel sizeToFit];
}

@end
