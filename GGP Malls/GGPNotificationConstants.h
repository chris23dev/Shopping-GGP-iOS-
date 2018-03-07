//
//  GGPNotificationConstants.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGPNotificationConstants : NSObject

extern NSString *const GGPShoppingFilterSelectedNotification;
extern NSString *const GGPDirectoryFilterSelectedNotification;
extern NSString *const GGPFilterSelectedUserInfoKey;

extern NSString *const GGPMallManagerMallChangedNotification;
extern NSString *const GGPMallManagerMallUpdatedNotification;
extern NSString *const GGPMallManagerMallInactiveNotification;
extern NSString *const GGPIsInitialMallSelectionUserInfoKey;

extern NSString *const GGPClientTenantsUpdatedNotification;
extern NSString *const GGPClientSalesUpdatedNotification;
extern NSString *const GGPClientEventsUpdatedNotification;
extern NSString *const GGPClientHeroesUpdatedNotification;
extern NSString *const GGPClientMovieTheatersUpdatedNotification;
extern NSString *const GGPClientAlertsUpdatedNotification;
extern NSString *const GGPClientParkAssistUpdatedNotification;

extern NSString *const GGPUserFavoritesUpdatedNotification;

extern NSString *const GGPJMapDataReadyNotification;

extern NSString *const GGPHeroDirectoryNotification;
extern NSString *const GGPHeroParkingNotification;
extern NSString *const GGPHeroCampaignNotification;
extern NSString *const GGPHeroCampaignCodeKey;

@end
