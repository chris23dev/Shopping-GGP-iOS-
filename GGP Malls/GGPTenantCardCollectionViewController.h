//
//  GGPTenantCardCollectionViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCardCollectionViewController.h"

@class GGPTenant;

@interface GGPTenantCardCollectionViewController : GGPCardCollectionViewController

@property (copy, nonatomic) void(^onCardSelected)(NSInteger index);
@property (copy, nonatomic) void(^onWayfindingTapped)(GGPTenant *tenant);

@end
