//
//  GGPMovieTheaterDetailsCell.h
//  GGP Malls
//
//  Created by Janet Lin on 2/2/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPMovieTheaterDetailsCellDelegate.h"

extern NSString *const GGPMovieTheaterDetailsCellReuseIdentifier;

@interface GGPMovieTheaterDetailsCell : UITableViewCell

@property id<GGPMovieTheaterDetailsCellDelegate> theaterDetailCellDelegate;
- (void)configureWithTheaterName:(NSString *)name Location:(NSString *)location andImageUrl:(NSURL *)logoUrl;

@end
