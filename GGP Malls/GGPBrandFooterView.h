//
//  GGPBrandFooterView.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const GGPBrandFooterViewReuseIdentifier;

@interface GGPBrandFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderViewHeightConstraint;

@end
