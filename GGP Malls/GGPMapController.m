//
//  GGPMapController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMallRepository.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMapController.h"
#import "GGPMapPlaceMarker.h"
#import "GGPTenant.h"
#import "NSArray+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <GoogleMaps/GoogleMaps.h>
#import <UIImageView+AFNetworking.h>

#ifdef PROD
static NSString *const kGoogleApiKey = @"AIzaSyAeT2JBywrtRt3EBkAYwkyYpTb81LPv9fw";
#else
static NSString *const kGoogleApiKey = @"AIzaSyC_N4Pibiv_RwynF7MYlm8o5egp1-JpeYo";
#endif

static NSString *const kMyLocationKey = @"myLocation";

@interface GGPMapController () <GMSMapViewDelegate>

@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) GGPMapOptions *mapOptions;
@property (strong, nonatomic) NSMutableArray *placeMarkers;
@property (strong, nonatomic) NSMutableArray *polygons;
@property (strong, nonatomic) GMSMarker *parkingMarker;

@property (assign, nonatomic) BOOL isObservingLocation;

@end

@implementation GGPMapController

- (instancetype)initWithMapOptions:(GGPMapOptions *)mapOptions andContainerView:(UIView *)containerView {
    self = [super init];
    if (self) {
        self.mapOptions = mapOptions;
        self.mapView = [self configureMapWithOptions:mapOptions andContainerView:containerView];
        self.placeMarkers = [NSMutableArray array];
        self.polygons = [NSMutableArray array];
        self.parkingMarker = [self configureParkingMarker];
     }
    return self;
}

- (void)dealloc {
    if (self.isObservingLocation) {
        [self stopObservingLocationForMapView:self.mapView];
    }
}

- (CLLocation *)userLocation {
    return self.mapView.myLocation;
}

- (CLLocation *)mapCenterLocation {
    CLLocationCoordinate2D coordinate = [self.mapView.projection coordinateForPoint:self.mapView.center];
    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

+ (void)initializeApiKey {
    [GMSServices provideAPIKey:kGoogleApiKey];
}

- (GMSMapView *)configureMapWithOptions:(GGPMapOptions *)options andContainerView:(UIView *)containerView {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:options.coordinates zoom:options.initialZoomLevel];
    GMSMapView *mapView = [GMSMapView mapWithFrame:containerView.bounds camera:camera];
    
    if (options.currentLocationEnabled) {
        [self startObservingLocationForMapView:mapView];
    }
    
    mapView.mapType = kGMSTypeTerrain;
    mapView.indoorEnabled = options.indoorsMapEnabled;
    mapView.myLocationEnabled = options.currentLocationEnabled;
    mapView.settings.myLocationButton = options.currentLocationEnabled;
    [mapView setMinZoom:mapView.minZoom maxZoom:options.maxZoomLevel];
    
    [containerView addSubview:mapView];
    [mapView ggp_addConstraintsToFillSuperview];
    
    mapView.delegate = self;
    
    return mapView;
}

- (GMSMarker *)configureParkingMarker {
    GMSMarker *parkingMarker = [GMSMarker new];
    parkingMarker.tracksViewChanges = NO;
    parkingMarker.icon = [UIImage imageNamed:@"ggp_parking_pin"];
    parkingMarker.appearAnimation = kGMSMarkerAnimationPop;
    parkingMarker.draggable = YES;
    return parkingMarker;
}

- (void)animateToLocation:(CLLocation *)location {
    GMSCameraUpdate *update = [GMSCameraUpdate setTarget:location.coordinate zoom:self.mapOptions.initialZoomLevel];
    [self.mapView animateWithCameraUpdate:update];
}

- (void)addPolygonWithPolyline:(NSString *)polyline andFillColor:(UIColor *)fillColor {
    @try {
        GMSPath *path = [GMSPath pathFromEncodedPath:polyline];
        
        GMSPolygon *polygon = [GMSPolygon polygonWithPath:path];
        polygon.fillColor = fillColor;
        polygon.map = self.mapView;
        
        [self.polygons addObject:polygon];
    } @catch (NSException *exception) {
        GGPLogError(@"Error adding polygon: %@", exception.description);
    }
}

- (void)fitToPolygons {
    GMSCoordinateBounds *bounds = [GMSCoordinateBounds new];
    [bounds includingCoordinate:self.mapOptions.coordinates];

    for (GMSPolygon *polygon in self.polygons) {
        [bounds includingPath:polygon.path];
    }

    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
    [self.mapView moveCamera:update];
}

- (void)fitToLocations:(NSArray *)locations {
    if (locations.count > 1) {
        GMSCoordinateBounds *bounds = [GMSCoordinateBounds new];
        
        for (CLLocation *location in locations) {
            bounds = [bounds includingCoordinate:location.coordinate];
        }
        
        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:80];
        [self.mapView moveCamera:update];
    } else {
        [self animateToLocation:locations.firstObject];
    }
}

- (void)displayAnchorTenantMarkers {
    [GGPMallRepository fetchTenantsWithCompletion:^(NSArray *tenants) {
        [self addPlaceMarkersForTenants:[self anchorTenantsFromTenants:tenants]];
    }];
}

- (void)displayParkingPinAtLocation:(CLLocation *)location {
    self.parkingMarker.position = location.coordinate;
    self.parkingMarker.map = self.mapView;
}

- (void)resetParkingPinLocation {
    [self clearParkingPin];
    
    if (self.mapView.myLocation) {
        [self.mapDelegate didDetermineLocation:self.mapView.myLocation];
    } else {
        [self startObservingLocationForMapView:self.mapView];
    }
}

- (void)resetPolygons {
    for (GMSPolygon *polygon in self.polygons) {
        polygon.map = nil;
    }
    
    [self.polygons removeAllObjects];
}

- (void)clearParkingPin {
    self.parkingMarker.position = kCLLocationCoordinate2DInvalid;
    self.parkingMarker.map = nil;
}

- (NSArray *)anchorTenantsFromTenants:(NSArray *)tenants {
    return [tenants ggp_arrayWithFilter:^BOOL(GGPTenant *tenant) {
        return tenant.isAnchor;
    }];
}

- (void)addPlaceMarkersForTenants:(NSArray *)tenants {
    for (GGPTenant *tenant in tenants) {
        GMSMarker *marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(tenant.latitude.floatValue, tenant.longitude.floatValue)];
        
        marker.tracksViewChanges = NO;
        marker.iconView = [[GGPMapPlaceMarker alloc] initWithTitle:tenant.name];
        marker.map = self.mapView;
        
        [self.placeMarkers addObject:marker];
    }
}

- (void)determinePlaceMarkerVisibilityForZoom:(float)zoom {
    BOOL placesHidden = zoom < self.mapOptions.placesZoomLevelThreshold;
    for (GMSMarker *marker in self.placeMarkers) {
        if (marker.iconView.hidden != placesHidden) {
            marker.iconView.hidden = placesHidden;
            
            // Always tracking view changes causes a CPU spike. So we want it to be set to NO until we need a redraw.
            // Note that when this changes from NO to YES, the icon is guaranteed to be redrawn next frame.
            marker.tracksViewChanges = YES;
            marker.tracksViewChanges = NO;
        }
    }
}

- (void)startObservingLocationForMapView:(GMSMapView *)mapView {
    [mapView addObserver:self forKeyPath:kMyLocationKey options:NSKeyValueObservingOptionNew context:nil];
    self.mapView.myLocationEnabled = YES;
    self.isObservingLocation = YES;
}

- (void)stopObservingLocationForMapView:(GMSMapView *)mapView {
    [mapView removeObserver:self forKeyPath:kMyLocationKey];
    self.isObservingLocation = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    [self stopObservingLocationForMapView:self.mapView];
    
    CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
    [self.mapDelegate didDetermineLocation:location];
}

#pragma mark GMSMapViewDelegate methods

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    [self determinePlaceMarkerVisibilityForZoom:position.zoom];
}

- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker {
    if (marker == self.parkingMarker) {
        [self.mapView animateToLocation:marker.position];
        [self.mapDelegate didUpdateParkingMarkerPosition:marker.position];
    }
}

@end
