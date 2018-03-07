//
//  GGPMovieTheaterDetailStackView.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPMovieTheaterDetailStackView : UIStackView

- (void)configureWithTheaters:(NSArray *)theaters andParentViewController:(UIViewController *)parentViewController;

@end
