//
//  GGPAmenityCollectionViewCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAmenityCollectionViewCell.h"
#import "GGPAmenity.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

NSString *const GGPAmenityCollectionViewCellReuseIdentifier = @"GGPAmenityCollectionViewCellReuseIdentifier";
CGFloat const GGPAmenityCollectionViewCellSize = 60;
CGFloat const GGPAmenityCollectionViewCellSpacing = 1;

@interface GGPAmenityCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) GGPAmenity *amenity;

@end

@implementation GGPAmenityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.font = [UIFont ggp_boldWithSize:8];
    self.nameLabel.textColor = [UIColor ggp_darkGray];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)configureWithAmenity:(GGPAmenity *)amenity {
    self.amenity = amenity;
    self.imageView.image = amenity.defaultImage;
    self.nameLabel.text = amenity.name;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.imageView.image = selected ? self.amenity.selectedImage : self.amenity.defaultImage;
    self.nameLabel.textColor = selected ? [UIColor whiteColor] : [UIColor ggp_darkGray];
    self.backgroundColor = selected ? [UIColor ggp_blue] : [UIColor whiteColor];
}

@end
