//
//  GGPEvent.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPPromotion.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GGPEvent : GGPPromotion <UIActivityItemSource>

// Mapped properties
@property (assign, nonatomic, readonly) NSInteger eventId;
@property (strong, nonatomic, readonly) NSString *eventDescription;
@property (strong, nonatomic, readonly) NSString *teaserDescription;
@property (assign, nonatomic, readonly) BOOL isFeatured;
@property (strong, nonatomic, readonly) NSArray *externalLinks;
@property (strong, nonatomic, readonly) NSString *eventImageUrl;

// Calculated properties
@property (assign, nonatomic, readonly) NSInteger mallId;
@property (assign, nonatomic, readonly) NSInteger tenantId;

@end
