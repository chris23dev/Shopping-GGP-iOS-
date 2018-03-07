//
//  GGPMovieTheaterDetailStackView.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMovieTheater.h"
#import "GGPMovieTheaterDetailStackView.h"
#import "GGPMultiTheaterDetailViewController.h"
#import "UIViewController+GGPAdditions.h"

static CGFloat const kStackViewSpacing = 20;

@interface GGPMovieTheaterDetailStackView ()

@end

@implementation GGPMovieTheaterDetailStackView

- (void)configureWithTheaters:(NSArray *)theaters andParentViewController:(UIViewController *)parentViewController {
    self.axis = UILayoutConstraintAxisVertical;
    self.spacing = kStackViewSpacing;
    self.layoutMargins = UIEdgeInsetsMake(kStackViewSpacing, kStackViewSpacing, kStackViewSpacing, kStackViewSpacing);
    self.layoutMarginsRelativeArrangement = YES;
    
    for (GGPMovieTheater *theater in theaters) {
        GGPMultiTheaterDetailViewController *detailViewController = [[GGPMultiTheaterDetailViewController alloc] initWithTheater:theater];
        [parentViewController ggp_addChildViewController:detailViewController toStackView:self];
    }
}

@end
