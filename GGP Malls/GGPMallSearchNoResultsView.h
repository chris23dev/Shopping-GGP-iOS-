//
//  GGPMallLocationSearchNoResultsView.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMallSearchNoResultsDelegate.h"
#import <UIKit/UIKit.h>

@interface GGPMallSearchNoResultsView : UIView

@property (weak, nonatomic) id <GGPMallSearchNoResultsDelegate> noResultsDelegate;

- (void)configureWithLabelText:(NSString *)label textColor:(UIColor *)textColor andButtonText:(NSString *)buttonText;

@end
