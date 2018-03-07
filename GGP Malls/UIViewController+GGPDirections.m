//
//  UIViewController+GGPDirections.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAddress.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPTenant.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import "UIViewController+GGPDirections.h"

static NSString *const kGoogleMapsScheme = @"comgooglemaps://";
static NSString *const kGoogleMapsURL = @"comgooglemaps://?q=%@,+%@";
static NSString *const kGoogleMapsLatLongURL = @"comgooglemaps://?q=%f,%f";
static NSString *const kAppleMapsURL = @"http://maps.apple.com/?q=%@,+%@";
static NSString *const kAppleMapsLatLongURL = @"http://maps.apple.com/?q=%f,%f";

@implementation UIViewController (GGPDirections)

- (NSAttributedString *)ggp_attributedDirectionsStringForTenant:(GGPTenant *)tenant {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self directionsLabelForTenant:tenant] attributes:@{ NSFontAttributeName:[UIFont ggp_regularWithSize:14] }];
    
    [attributedString addAttribute:NSLinkAttributeName value:@"directions" range:[attributedString.string rangeOfString:[@"DETAILS_DIRECTIONS_NON_PROXIMITY" ggp_toLocalized]]];
    return attributedString;
}

- (NSString *)serializedTenantName:(NSString *)tenantName {
    return [tenantName stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
}

- (void)ggp_getDirectionsForTenant:(GGPTenant *)tenant {
    NSString *mapsScheme = [self canOpenScheme:kGoogleMapsScheme] ? kGoogleMapsURL : kAppleMapsURL;
    NSString *serializedTenantName = [self serializedTenantName:tenant.name];
    NSString *directionsString = [self directionsStringForMapScheme:mapsScheme andTenantName:serializedTenantName];
    NSURL *url = [NSURL URLWithString:directionsString];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)ggp_getDirectionsForLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude {
    NSString *mapsScheme = [self canOpenScheme:kGoogleMapsScheme] ? kGoogleMapsLatLongURL : kAppleMapsLatLongURL;
    NSString *directionsString = [NSString stringWithFormat:mapsScheme, latitude, longitude];
    NSURL *url = [NSURL URLWithString:directionsString];
    [[UIApplication sharedApplication] openURL:url];
}

- (NSString *)directionsStringForMapScheme:(NSString *)mapsScheme andTenantName:(NSString *)tenantName {
    GGPMall *selectedMall = [GGPMallManager shared].selectedMall;
    NSString *urlString = [NSString stringWithFormat:mapsScheme, tenantName, selectedMall.address.fullAddress];
    return [urlString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
}

- (NSString *)directionsLabelForTenant:(GGPTenant *)tenant {
    NSString *parkingLocationDescription = [[GGPJMapManager shared].mapViewController parkingLocationDescriptionForTenant:tenant];
    return !parkingLocationDescription.length ? [@"DETAILS_DIRECTIONS_NON_PROXIMITY" ggp_toLocalized] : [NSString stringWithFormat:[@"DETAILS_DIRECTIONS_WITH_PROXIMITY" ggp_toLocalized], parkingLocationDescription];
}

@end
