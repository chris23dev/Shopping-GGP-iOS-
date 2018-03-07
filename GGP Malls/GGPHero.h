//
//  GGPHero.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

@interface GGPHero : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *heroDescription;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *urlText;

@end
