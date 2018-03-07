//
//  GGPSocialMedia.h
//  GGP Malls
//
//  Created by Janet Lin on 1/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

@interface GGPSocialMedia : MTLModel <MTLJSONSerializing>
@property (strong, nonatomic, readonly) NSURL *facebookUrl;
@property (strong, nonatomic, readonly) NSURL *instagramUrl;
@property (strong, nonatomic, readonly) NSURL *pinterestUrl;
@property (strong, nonatomic, readonly) NSURL *twitterUrl;

@end
