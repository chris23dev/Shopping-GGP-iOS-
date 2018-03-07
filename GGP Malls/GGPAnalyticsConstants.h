//
//  GGPAnalyticsConstants.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 1/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGPAnalyticsConstants : NSObject

#pragma mark Screens
extern NSString *const GGPAnalyticsScreenHome;
extern NSString *const GGPAnalyticsScreenDirectory;
extern NSString *const GGPAnalyticsScreenDirectoryMap;
extern NSString *const GGPAnalyticsScreenSales;
extern NSString *const GGPAnalyticsScreenSalesDetail;
extern NSString *const GGPAnalyticsScreenDining;
extern NSString *const GGPAnalyticsScreenMovies; 
extern NSString *const GGPAnalyticsScreenTenantDetail; 
extern NSString *const GGPAnalyticsScreenTenantDetailMap;
extern NSString *const GGPAnalyticsScreenEvents;
extern NSString *const GGPAnalyticsScreenEventDetails;
extern NSString *const GGPAnalyticsScreenParking;
extern NSString *const GGPAnalyticsScreenParkingReminder;
extern NSString *const GGPAnalyticsScreenParkingAvailability;
extern NSString *const GGPAnalyticsScreenMore;
extern NSString *const GGPAnalyticsScreenMyInformation;
extern NSString *const GGPAnalyticsScreenMallInfo;
extern NSString *const GGPAnalyticsScreenMallSelection;
extern NSString *const GGPAnalyticsScreenFeedback;
extern NSString *const GGPAnalyticsScreenTermsConditions;
extern NSString *const GGPAnalyticsScreenPrivacy;
extern NSString *const GGPAnalyticsScreenAccount;
extern NSString *const GGPAnalyticsScreenRegister;
extern NSString *const GGPAnalyticsScreenWayfinding;

#pragma mark Actions
extern NSString *const GGPAnalyticsActionAlert;
extern NSString *const GGPAnalyticsActionTileTap;
extern NSString *const GGPAnalyticsActionNavParkingReminder;
extern NSString *const GGPAnalyticsActionNavTermsAndConditions;
extern NSString *const GGPAnalyticsActionNavMallHours; // NOT AVAILABLE
extern NSString *const GGPAnalyticsActionNavPrivacy;
extern NSString *const GGPAnalyticsActionNavCall;
extern NSString *const GGPAnalyticsActionNavDirections;
extern NSString *const GGPAnalyticsActionNavSocialBadge;
extern NSString *const GGPAnalyticsActionSearchByLocation;
extern NSString *const GGPAnalyticsActionSearchByMallName;
extern NSString *const GGPAnalyticsActionSelectedMall;
extern NSString *const GGPAnalyticsActionDirectoryChangeView;
extern NSString *const GGPAnalyticsActionDirectoryFilterItem;
extern NSString *const GGPAnalyticsActionDirectoryRegister;
extern NSString *const GGPAnalyticsActionParkingForTenant;
extern NSString *const GGPAnalyticsActionParkingGetDirections;
extern NSString *const GGPAnalyticsActionParkingReminderAddPhoto;
extern NSString *const GGPAnalyticsActionParkingReminderSave;
extern NSString *const GGPAnalyticsActionParkingReminderAddNote;
extern NSString *const GGPAnalyticsActionParkingAvailabilityMenu;
extern NSString *const GGPAnalyticsActionParkingFindMyCar;
extern NSString *const GGPAnalyticsActionParkingAvailabilityByLevel;
extern NSString *const GGPAnalyticsActionTenantCall;
extern NSString *const GGPAnalyticsActionTenantOpenTable;
extern NSString *const GGPAnalyticsActionTenantWebsite;
extern NSString *const GGPAnalyticsActionTenantHours;
extern NSString *const GGPAnalyticsActionTenantMap;
extern NSString *const GGPAnalyticsActionTenantGuideMe;
extern NSString *const GGPAnalyticsActionTenantGetDirections;
extern NSString *const GGPAnalyticsActionTenantFavoriteTap;
extern NSString *const GGPAnalyticsActionTenantRegister;
extern NSString *const GGPAnalyticsActionTenantStoreInStore;
extern NSString *const GGPAnalyticsActionBuyTickets;
extern NSString *const GGPAnalyticsActionWayfindingNavigate;
extern NSString *const GGPAnalyticsActionWayfindingRouteList;
extern NSString *const GGPAnalyticsActionAccountChangeSettings;
extern NSString *const GGPAnalyticsActionAccountChangePersonalInfo;
extern NSString *const GGPAnalyticsActionAccountChangePassword;
extern NSString *const GGPAnalyticsActionLogin;
extern NSString *const GGPAnalyticsActionRegisterSubmit;
extern NSString *const GGPAnalyticsActionSocialShare;
extern NSString *const GGPAnalyticsActionNavigationChangeMall;
extern NSString *const GGPAnalyticsActionShoppingCategory;
extern NSString *const GGPAnalyticsActionShoppingSubCategory;
extern NSString *const GGPAnalyticsActionShoppingFilterStore;
extern NSString *const GGPAnalyticsActionShoppingFilterSort;
extern NSString *const GGPAnalyticsActionMultiTheaterMallTheater;
extern NSString *const GGPAnalyticsActionAmenitiesCategory;

#pragma mark Context Data keys
extern NSString *const GGPAnalyticsContextDataTileName;
extern NSString *const GGPAnalyticsContextDataTileType;
extern NSString *const GGPAnalyticsContextDataTilePosition;
extern NSString *const GGPAnalyticsContextDataSearchMallKeyword;
extern NSString *const GGPAnalyticsContextDataSearchMallCount;
extern NSString *const GGPAnalyticsContextDataSelectedMallCoordinates;
extern NSString *const GGPAnalyticsContextDataSelectedMallDistance;
extern NSString *const GGPAnalyticsContextDataSelectedMallName;
extern NSString *const GGPAnalyticsContextDataDirectoryViewType;
extern NSString *const GGPAnalyticsContextDataDirectoryFilterCategory;
extern NSString *const GGPAnalyticsContextDataDirectoryFilterBrand;
extern NSString *const GGPAnalyticsContextDataDirectoryFilterProduct;
extern NSString *const GGPAnalyticsContextDataParkingTenant;
extern NSString *const GGPAnalyticsContextDataBuyTicketsMovieName;
extern NSString *const GGPAnalyticsContextDataBuyTicketsDaysInAdvance;
extern NSString *const GGPAnalyticsContextDataMallPhoneNumber;
extern NSString *const GGPAnalyticsContextDataMallSocialNetwork;
extern NSString *const GGPAnalyticsContextDataTenantPhoneNumber;
extern NSString *const GGPAnalyticsContextDataTenantName;
extern NSString *const GGPAnalyticsContextDataWayfindingStartTenant;
extern NSString *const GGPAnalyticsContextDataWayfindingEndTenant;
extern NSString *const GGPAnalyticsContextDataWayfindingStartLevel;
extern NSString *const GGPAnalyticsContextDataWayfindingEndLevel;
extern NSString *const GGPAnalyticsContextDataAccountEmailOptIn;
extern NSString *const GGPAnalyticsContextDataAccountTextOptIn;
extern NSString *const GGPAnalyticsContextDataTenantFavoriteStatus;
extern NSString *const GGPAnalyticsContextDataEventSaleName;
extern NSString *const GGPAnalyticsContextDataSocialNetwork;

extern NSString *const GGPAnalyticsContextDataAccountAuthType;
extern NSString *const GGPAnalyticsContextDataAccountFormName;
extern NSString *const GGPAnalyticsContextDataAccountLeadType;
extern NSString *const GGPAnalyticsContextDataAccountLeadLevel;
extern NSString *const GGPAnalyticsContextDataAccountAuthStatus;
extern NSString *const GGPAnalyticsContextDataAccountUserId;
extern NSString *const GGPAnalyticsContextDataAccountSweepstakes;

extern NSString *const GGPAnalyticsContextDataParkingDaysInAdvance;
extern NSString *const GGPAnalyticsContextDataParkingTimeOfDay;

extern NSString *const GGPAnalyticsContextDataShoppingCategoryName;
extern NSString *const GGPAnalyticsContextDataShoppingSubCategoryName;
extern NSString *const GGPAnalyticsContextDataShoppingFilterStore;
extern NSString *const GGPAnalyticsContextDataShoppingFilterSort;

extern NSString *const GGPAnalyticsContextDataMultiTheaterMallTheater;

extern NSString *const GGPAnalyticsContextDataAmenitiesCategory;

#pragma mark Context Data values
extern NSString *const GGPAnalyticsContextDataDirectoryViewTypeList;
extern NSString *const GGPAnalyticsContextDataDirectoryViewTypeMap;
extern NSString *const GGPAnalyticsContextDataSocialNetworkTypeTwitter;
extern NSString *const GGPAnalyticsContextDataSocialNetworkTypePinterest;
extern NSString *const GGPAnalyticsContextDataSocialNetworkTypeInstagram;
extern NSString *const GGPAnalyticsContextDataSocialNetworkTypeFacebook;
extern NSString *const GGPAnalyticsContextDataSocialNetworkTypeEmail;
extern NSString *const GGPAnalyticsContextDataSocialNetworkTypeText;
extern NSString *const GGPAnalyticsContextDataAuthTypeFacebook;
extern NSString *const GGPAnalyticsContextDataAuthTypeGoogle;
extern NSString *const GGPAnalyticsContextDataAuthTypeSite;
extern NSString *const GGPAnalyticsContextDataAccountTypeSiteRegistration;
extern NSString *const GGPAnalyticsContextDataLeadLevelTypeEmail;
extern NSString *const GGPAnalyticsContextDataAuthStatusTypeAuthenticated;
extern NSString *const GGPAnalyticsContextDataAuthStatusTypeNotAuthenticated;
extern NSString *const GGPAnalyticsContextDataUserIdTypeGuest;
extern NSString *const GGPAnalyticsContextDataTenantFavoriteStatusFavorite;
extern NSString *const GGPAnalyticsContextDataTenantFavoriteStatusUnFavorite;

@end
