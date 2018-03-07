//
//  GGPMapControllerDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/16/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GGPMapControllerDelegate <NSObject>

- (void)didDetermineLocation:(CLLocation *)location;

- (void)didUpdateParkingMarkerPosition:(CLLocationCoordinate2D)position;

@end
