//
//  DeviceLocation.m
//  SeismicXML
//
//  Created by Craig Schamp on 7/18/09.
//  Copyright 2009 Craig Schamp. All rights reserved.
//

#import "DeviceLocation.h"
#import <math.h>

@implementation DeviceLocation

@synthesize latitude;
@synthesize longitude;
@synthesize isRecent;

- (id) init
{
	self = [super init];
	if (self != nil) {
		isRecent = NO;
		latitude = 0.0;
		longitude = 0.0;
		locationManager = nil;
	}
	return self;
}

- (void) dealloc
{
	[locationManager release];
	[super dealloc];
}


// See iPhone Application Programming Guide, 2009-060-17, pp. 163-165
- (void)startUpdates 
{ 
    // Create the location manager if this object does not already have one. 
    if (locationManager == nil) 
        locationManager = [[CLLocationManager alloc] init]; 
    locationManager.delegate = self; 
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer; 
    // Set a movement threshold for new events 
    locationManager.distanceFilter = 500; 
    [locationManager startUpdatingLocation]; 
}

// Delegate method from the CLLocationManagerDelegate protocol. 
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{ 
    // If it's a relatively recent event, turn off updates to save power 
    NSDate* eventDate = newLocation.timestamp; 
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow]; 
    if (abs(howRecent) < 5.0) { 
        [manager stopUpdatingLocation];
		isRecent = YES;
		self.latitude = newLocation.coordinate.latitude;
		self.longitude = newLocation.coordinate.longitude;
        // XXX printf("latitude %+.6f, longitude %+.6f\n", newLocation.coordinate.latitude, newLocation.coordinate.longitude); 
    } 
    // else skip the event and process the next one. 
}

// Calculate the distance from current location to the specified point
// Adapted from http://www.zipcodeworld.com/samples/distance.c.html
#define deg2rad(deg) (deg * M_PI / 180)
#define rad2deg(rad) (rad * 180 / M_PI)
// XXX Perhaps a better interface is
// XXX - (double)distanceToCoordinate:(DLCoordinate *)coordinate asUnits:(DLunits)Units
- (double)distanceToPoint:(DLunits)Units latitude:(double)toLatitude longitude:(double)toLongitude
{
	double theta, dist;
	theta = self.longitude - toLongitude;
	dist = sin(deg2rad(self.latitude)) * sin(deg2rad(toLatitude)) + cos(deg2rad(self.latitude)) * cos(deg2rad(toLatitude)) * cos(deg2rad(theta));
	dist = acos(dist);
	dist = rad2deg(dist);
	dist = dist * 60 * 1.1515;
	switch (Units) {
		// XXX defaulting to statute miles for now
		default: case DLStatuteMiles: break;
		case DLKilometers: dist = dist * 1.609344; break;
		case DLNauticalMiles: dist = dist * 0.8684; break;
	}
	return (dist);
}

@end
