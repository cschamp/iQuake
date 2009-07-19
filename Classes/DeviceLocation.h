//
//  DeviceLocation.h
//  SeismicXML
//
//  Created by Craig Schamp on 7/18/09.
//  Copyright 2009 Craig Schamp. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <CoreLocation/CoreLocation.h>

typedef enum {
	DLStatuteMiles = 0,
	DLKilometers = 1,
	DLNauticalMiles = 2,
} DLunits;

@interface DeviceLocation : NSObject <CLLocationManagerDelegate> {
	@private
	CLLocationManager *locationManager;
	double latitude;
	double longitude;
	BOOL isRecent;
}

- (void)startUpdates;
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
// XXX Perhaps a better interface is
// XXX - (double)distanceToCoordinate:(DLCoordinate *)coordinate asUnits:(DLunits)Units
- (double)distanceToPoint:(DLunits)Units latitude:(double)toLatitude longitude:(double)toLongitude;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) BOOL isRecent; 

@end
