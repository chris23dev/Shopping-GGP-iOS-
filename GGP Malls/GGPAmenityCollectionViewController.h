//
//  GGPAmenityCollectionViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPAmenityCollectionViewController : UICollectionViewController

- (void)configureWithAmenities:(NSArray *)amenities;
- (void)resetAmenitySelection;

@end
