//
//  GGPJmapViewController+Highlighting.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJmapViewController+Highlighting.h"
#import "GGPJmapViewcontroller+Levels.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPTenant.h"
#import "GGPTenantDetailCardDelegate.h"
#import "GGPTenantDetailCardViewController.h"
#import "UIColor+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <JMap/JMap.h>

static NSString *const kTappedUnitHighlightColor = @"0098CC";
static NSString *const kSelectedUnitHighlightColor = @"7AB8CC";

@interface GGPJMapViewController () <GGPTenantDetailCardDelegate>

@property (weak, nonatomic) IBOutlet UIView *detailCardContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailCardContainerBottomConstraint;

@property (strong, nonatomic) GGPTenantDetailCardViewController *tenantDetailCardViewController;
@property (strong, nonatomic) NSMutableArray *highlightedDestinations;
@property (strong, nonatomic) JMapContainerView *mapView;
@property (strong, nonatomic) NSArray *allDestinations;
@property (strong, nonatomic) GGPTenant *tenantToDisplay;

@end

@implementation GGPJMapViewController (Highlighting)

- (void)handleTappedDestination:(JMapDestination *)tappedDestination {
    if (self.highlightedDestinations.count) {
        [self unhighlightUnitsBasedOnFilters];
    } else {
        [self.mapView unhighlightAllUnits];
    }
    
    self.tenantToDisplay = [self.mapViewControllerDelegate tenantFromLeaseId:[self leaseIdFromDestinationClientId:tappedDestination.clientId]];
    
    if (!self.tenantToDisplay) {
        [self resetMapView];
    } else if (!self.tenantDetailCardViewController) {
        [self highlightTappedDestination:tappedDestination];
        [self displayDetailCardForTenant:self.tenantToDisplay];
    } else {
        [self highlightTappedDestination:tappedDestination];
        [self.tenantDetailCardViewController updateWithTenant:self.tenantToDisplay];
    }
}

- (void)highlightDestination:(JMapDestination *)destination withColorHex:(NSString *)colorHex {
    [self.mapView setDestinationHighlight:destination withColor:[UIColor ggp_colorFromHexString:colorHex]];
}

- (void)highlightTappedDestination:(JMapDestination *)tappedDestination {
    [self highlightDestination:tappedDestination withColorHex:kTappedUnitHighlightColor];
}

- (void)highlightSelectedDestination:(JMapDestination *)selectedDestination {
    [self highlightDestination:selectedDestination withColorHex:kSelectedUnitHighlightColor];
}

- (void)highlightTenants:(NSArray *)tenants {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.highlightedDestinations = [NSMutableArray new];
        [self.mapView unhighlightAllUnits];
        for (GGPTenant *tenant in tenants) {
            JMapDestination *destinationFromTenant = [self retrieveDestinationFromLeaseId:tenant.leaseId];
            if (destinationFromTenant) {
                [self.highlightedDestinations addObject:destinationFromTenant];
            }
            [self highlightSelectedDestination:destinationFromTenant];
        }
    });
}

- (void)unhighlightUnitsBasedOnFilters {
    for (JMapDestination *destination in self.allDestinations) {
        if (![self.highlightedDestinations containsObject:destination]) {
            [self.mapView setDestinationUnHighlight:destination];
        } else {
            [self highlightSelectedDestination:destination];
        }
    }
}

- (void)clearHighlightedDestinations {
    self.highlightedDestinations = [NSMutableArray new];
}

@end
