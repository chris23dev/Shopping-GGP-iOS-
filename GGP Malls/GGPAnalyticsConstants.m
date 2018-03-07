//
//  GGPAnalyticsConstants.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 1/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAnalyticsConstants.h"

@implementation GGPAnalyticsConstants

#pragma mark Screens
NSString *const GGPAnalyticsScreenHome = @"home";
NSString *const GGPAnalyticsScreenDirectory = @"directory list";
NSString *const GGPAnalyticsScreenDirectoryMap = @"directory map";
NSString *const GGPAnalyticsScreenSales = @"shopping";
NSString *const GGPAnalyticsScreenSalesDetail = @"sale detail";
NSString *const GGPAnalyticsScreenDining = @"dining";
NSString *const GGPAnalyticsScreenMovies = @"movies";
NSString *const GGPAnalyticsScreenTenantDetail = @"tenant detail";
NSString *const GGPAnalyticsScreenTenantDetailMap = @"tenant map";
NSString *const GGPAnalyticsScreenEvents = @"events";
NSString *const GGPAnalyticsScreenEventDetails = @"event details";
NSString *const GGPAnalyticsScreenParking = @"parking info";
NSString *const GGPAnalyticsScreenParkingReminder = @"parking reminder";
NSString *const GGPAnalyticsScreenParkingAvailability = @"parking availability";
NSString *const GGPAnalyticsScreenMore = @"more";
NSString *const GGPAnalyticsScreenMyInformation = @"my information";
NSString *const GGPAnalyticsScreenMallInfo = @"mall info";
NSString *const GGPAnalyticsScreenMallSelection = @"mall selection";
NSString *const GGPAnalyticsScreenFeedback = @"feedback";
NSString *const GGPAnalyticsScreenTermsConditions = @"terms and conditions";
NSString *const GGPAnalyticsScreenPrivacy = @"privacy";
NSString *const GGPAnalyticsScreenAccount = @"account";
NSString *const GGPAnalyticsScreenRegister = @"register";
NSString *const GGPAnalyticsScreenWayfinding = @"wayfinding";

#pragma mark Actions
NSString *const GGPAnalyticsActionAlert = @"appevent.globalalert";
NSString *const GGPAnalyticsActionTileTap = @"appevent.tile.tap";
NSString *const GGPAnalyticsActionNavParkingReminder = @"appevent.navigation.setremindertap";
NSString *const GGPAnalyticsActionNavTermsAndConditions = @"appevent.navigation.terms";
NSString *const GGPAnalyticsActionNavMallHours = @"appevent.navigation.mallhours";
NSString *const GGPAnalyticsActionNavPrivacy = @"appevent.navigation.privacy";
NSString *const GGPAnalyticsActionNavCall = @"appevent.navigation.taptocall";
NSString *const GGPAnalyticsActionNavDirections = @"appevent.navigation.addresstap";
NSString *const GGPAnalyticsActionNavSocialBadge = @"appevent.navigation.socialbadge";
NSString *const GGPAnalyticsActionSearchByLocation = @"appevent.search.location";
NSString *const GGPAnalyticsActionSearchByMallName = @"appevent.search.mallname";
NSString *const GGPAnalyticsActionSelectedMall = @"appevent.search.mallselected";
NSString *const GGPAnalyticsActionDirectoryChangeView = @"appevent.directory.changeview";
NSString *const GGPAnalyticsActionDirectoryFilterItem = @"appevent.directory.categorytap";
NSString *const GGPAnalyticsActionDirectoryRegister = @"appevent.directory.register";
NSString *const GGPAnalyticsActionParkingForTenant = @"appevent.parking.findcomplete";
NSString *const GGPAnalyticsActionParkingGetDirections = @"appevent.parking.getdirections";
NSString *const GGPAnalyticsActionParkingReminderAddPhoto = @"appevent.parking.addphoto";
NSString *const GGPAnalyticsActionParkingReminderSave = @"appevent.parking.savereminder";
NSString *const GGPAnalyticsActionParkingReminderAddNote = @"appevent.parking.addnote";
NSString *const GGPAnalyticsActionParkingAvailabilityMenu = @"appevent.parking.availabilitymenu";
NSString *const GGPAnalyticsActionParkingFindMyCar = @"appevent.parking.findmycar";
NSString *const GGPAnalyticsActionParkingAvailabilityByLevel = @"appevent.parking.availabilitybylevel";
NSString *const GGPAnalyticsActionTenantCall = @"appevent.tenant.phonetap";
NSString *const GGPAnalyticsActionTenantOpenTable = @"appevent.tenant.opentabletap";
NSString *const GGPAnalyticsActionTenantWebsite = @"appevent.tenant.websitetap";
NSString *const GGPAnalyticsActionTenantHours = @"appevent.tenant.hourstap";
NSString *const GGPAnalyticsActionTenantMap = @"appevent.tenant.directorymaptap";
NSString *const GGPAnalyticsActionTenantGuideMe = @"appevent.tenant.guidemetap";
NSString *const GGPAnalyticsActionTenantRegister = @"appevent.tenant.register";
NSString *const GGPAnalyticsActionTenantGetDirections = @"appevent.tenant.getdirections";
NSString *const GGPAnalyticsActionTenantFavoriteTap = @"appevent.tenant.favoritetap";
NSString *const GGPAnalyticsActionTenantStoreInStore = @"appevent.tenant.storeinstore";
NSString *const GGPAnalyticsActionBuyTickets = @"appevent.fandango.buytickets";
NSString *const GGPAnalyticsActionWayfindingNavigate = @"appevent.wayfinding.navigate";
NSString *const GGPAnalyticsActionWayfindingRouteList = @"appevent.wayfinding.routelist";
NSString *const GGPAnalyticsActionAccountChangeSettings = @"appevent.account.changesettings";
NSString *const GGPAnalyticsActionAccountChangePersonalInfo = @"appevent.account.changepersonalinfo";
NSString *const GGPAnalyticsActionAccountChangePassword = @"appevent.account.changepassword";
NSString *const GGPAnalyticsActionLogin = @"appevent.authentication.submit";
NSString *const GGPAnalyticsActionRegisterSubmit = @"appevent.registration.submit";
NSString *const GGPAnalyticsActionSocialShare = @"appevent.social.share";
NSString *const GGPAnalyticsActionNavigationChangeMall = @"appevent.navigation.changemall";
NSString *const GGPAnalyticsActionShoppingCategory = @"appevent.shopping.category";
NSString *const GGPAnalyticsActionShoppingSubCategory = @"appevent.shopping.subcategory";
NSString *const GGPAnalyticsActionShoppingFilterStore = @"appevent.shopping.filter.store";
NSString *const GGPAnalyticsActionShoppingFilterSort = @"appevent.shopping.filter.sort";
NSString *const GGPAnalyticsActionMultiTheaterMallTheater = @"appevent.multitheatermall.theater";
NSString *const GGPAnalyticsActionAmenitiesCategory = @"appevent.amenities.category";

#pragma mark Context Data keys

// Tap on tile action
NSString *const GGPAnalyticsContextDataTileName = @"tile.name";
NSString *const GGPAnalyticsContextDataTileType = @"tile.type";
NSString *const GGPAnalyticsContextDataTilePosition = @"tile.position";

// Search mall by zip action
NSString *const GGPAnalyticsContextDataSearchMallKeyword = @"search.keyword";
NSString *const GGPAnalyticsContextDataSearchMallCount = @"search.total";

// Select mall action
NSString *const GGPAnalyticsContextDataSelectedMallCoordinates = @"mall.coordinates";
NSString *const GGPAnalyticsContextDataSelectedMallDistance = @"mall.distance";
NSString *const GGPAnalyticsContextDataSelectedMallName = @"mall.name";

// Directory view type changed action
NSString *const GGPAnalyticsContextDataDirectoryViewType = @"directory.viewtype";

// Filter action
NSString *const GGPAnalyticsContextDataDirectoryFilterCategory = @"directory.categoryname";
NSString *const GGPAnalyticsContextDataDirectoryFilterBrand = @"directory.brandname";
NSString *const GGPAnalyticsContextDataDirectoryFilterProduct = @"directory.productname";

// Parking info changed store action
NSString *const GGPAnalyticsContextDataParkingTenant = @"findparking.storename";

// Tap on buy tickets or fandango button action
NSString *const GGPAnalyticsContextDataBuyTicketsMovieName = @"fandango.moviename";
NSString *const GGPAnalyticsContextDataBuyTicketsDaysInAdvance = @"fandango.daysinadvance";

// Navigation mall information
NSString *const GGPAnalyticsContextDataMallPhoneNumber = @"mall.phonenumber";
NSString *const GGPAnalyticsContextDataMallSocialNetwork = @"social.network";

// Tenant detail information
NSString *const GGPAnalyticsContextDataTenantPhoneNumber = @"tenant.phonenumber";
NSString *const GGPAnalyticsContextDataTenantName = @"tenant.name";

// Wayfinding
NSString *const GGPAnalyticsContextDataWayfindingStartTenant = @"wayfinding.start";
NSString *const GGPAnalyticsContextDataWayfindingEndTenant = @"wayfinding.end";
NSString *const GGPAnalyticsContextDataWayfindingStartLevel = @"wayfinding.startlevel";
NSString *const GGPAnalyticsContextDataWayfindingEndLevel = @"wayfinding.endlevel";

// Favorites
NSString *const GGPAnalyticsContextDataTenantFavoriteStatus = @"tenant.favoritestatus";

// Sharing
NSString *const GGPAnalyticsContextDataEventSaleName = @"eventsale.name";
NSString *const GGPAnalyticsContextDataSocialNetwork = @"social.network";

// Account
NSString *const GGPAnalyticsContextDataAccountEmailOptIn = @"account.emailoptin";
NSString *const GGPAnalyticsContextDataAccountTextOptIn = @"account.textoptin";
NSString *const GGPAnalyticsContextDataAccountAuthType = @"auth.type";
NSString *const GGPAnalyticsContextDataAccountFormName = @"form.name";
NSString *const GGPAnalyticsContextDataAccountLeadType = @"customer.leadtype";
NSString *const GGPAnalyticsContextDataAccountLeadLevel = @"customer.leadlevel";
NSString *const GGPAnalyticsContextDataAccountAuthStatus = @"auth.status";
NSString *const GGPAnalyticsContextDataAccountUserId = @"user.id";
NSString *const GGPAnalyticsContextDataAccountSweepstakes = @"account.sweepstakes";

// Parking
NSString *const GGPAnalyticsContextDataParkingDaysInAdvance = @"parking.daysinadvance";
NSString *const GGPAnalyticsContextDataParkingTimeOfDay = @"parking.timeofday";

//Shopping
NSString *const GGPAnalyticsContextDataShoppingCategoryName = @"shopping.categoryname";
NSString *const GGPAnalyticsContextDataShoppingSubCategoryName = @"shopping.subcategoryname";
NSString *const GGPAnalyticsContextDataShoppingFilterStore = @"shopping.filterstore";
NSString *const GGPAnalyticsContextDataShoppingFilterSort = @"shopping.filtersort";

//Theater
NSString *const GGPAnalyticsContextDataMultiTheaterMallTheater = @"multitheatermall.theater";

//Amenities
NSString *const GGPAnalyticsContextDataAmenitiesCategory = @"amenities.category";

#pragma mark Context Data values
NSString *const GGPAnalyticsContextDataDirectoryViewTypeList = @"list";
NSString *const GGPAnalyticsContextDataDirectoryViewTypeMap = @"map";
NSString *const GGPAnalyticsContextDataSocialNetworkTypeTwitter = @"twitter";
NSString *const GGPAnalyticsContextDataSocialNetworkTypePinterest = @"pinterest";
NSString *const GGPAnalyticsContextDataSocialNetworkTypeInstagram = @"instagram";
NSString *const GGPAnalyticsContextDataSocialNetworkTypeFacebook = @"facebook";
NSString *const GGPAnalyticsContextDataSocialNetworkTypeEmail = @"email";
NSString *const GGPAnalyticsContextDataSocialNetworkTypeText = @"text";
NSString *const GGPAnalyticsContextDataAuthTypeFacebook = @"facebook";
NSString *const GGPAnalyticsContextDataAuthTypeGoogle = @"google plus";
NSString *const GGPAnalyticsContextDataAuthTypeSite = @"form entry";
NSString *const GGPAnalyticsContextDataAccountTypeSiteRegistration = @"site registration";
NSString *const GGPAnalyticsContextDataLeadLevelTypeEmail = @"partial: email";
NSString *const GGPAnalyticsContextDataAuthStatusTypeAuthenticated = @"authenticated";
NSString *const GGPAnalyticsContextDataAuthStatusTypeNotAuthenticated = @"not authenticated";
NSString *const GGPAnalyticsContextDataUserIdTypeGuest = @"guest";
NSString *const GGPAnalyticsContextDataTenantFavoriteStatusFavorite = @"favorite";
NSString *const GGPAnalyticsContextDataTenantFavoriteStatusUnFavorite = @"unfavorite";

@end
