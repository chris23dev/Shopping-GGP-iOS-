//
//  GGPAmenityCollectionViewCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPAmenity;

extern NSString *const GGPAmenityCollectionViewCellReuseIdentifier;
extern CGFloat const GGPAmenityCollectionViewCellSize;
extern CGFloat const GGPAmenityCollectionViewCellSpacing;

@interface GGPAmenityCollectionViewCell : UICollectionViewCell

- (void)configureWithAmenity:(GGPAmenity *)amenity;

@end
