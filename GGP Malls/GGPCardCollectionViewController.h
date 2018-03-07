//
//  GGPCardCollectionViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/16/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPCardCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSArray *data;
- (void)configureWithData:(NSArray *)data;
- (void)trackActionWithTitle:(NSString *)tileTitle type:(NSString *)tileType andRowIndex:(NSInteger)rowIndex;

@end
