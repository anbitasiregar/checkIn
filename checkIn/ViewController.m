//
//  ViewController.m
//  checkIn
//
//  Created by Anbita Siregar on 6/17/15.
//  Copyright (c) 2015 Anbita Siregar. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "slackWebhookManager.h"

@interface ViewController()
@property (strong, nonatomic) CLCircularRegion *monitoredRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.monitorButton.layer.cornerRadius = 5;
    self.monitorButton.layer.masksToBounds = YES;
    self.currentLocationButton.layer.cornerRadius = 5;
    self.currentLocationButton.layer.masksToBounds = YES;
    self.currentLocationButton.enabled = NO;
    self.getDirectionsButton.layer.cornerRadius = 5;
    self.getDirectionsButton.layer.masksToBounds = YES;
    self.mapView.showsUserLocation = YES;
    MKPointAnnotation *intrepid = [[MKPointAnnotation alloc] init];
    intrepid.coordinate = CLLocationCoordinate2DMake(42.36723809, -71.08061388);
    [self.mapView addAnnotation:intrepid];
    
    
    self.monitoredRegion = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(42.36723809, -71.08061388) radius:100 identifier:@"test"];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    if ([self.locationManager.monitoredRegions containsObject:self.monitoredRegion]) {
        self.stopMonitorButton.hidden = NO;
    } else {
        self.stopMonitorButton.hidden = YES;
    }
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - UIButton Delegates
- (IBAction)monitorButtonPressed:(UIButton *)sender {
    [self.locationManager startMonitoringForRegion:self.monitoredRegion];
    NSLog(@"Started monitoring");
    [self.monitorButton setTitle:@"Monitoring..." forState:UIControlStateNormal];
    self.stopMonitorButton.hidden = NO;
}
- (IBAction)stopMonitorButtonPressed:(UIButton *)sender {
    [self.locationManager stopMonitoringForRegion:self.monitoredRegion];
    NSLog(@"Stopped monitoring");
    [self.monitorButton setTitle:@"Start Monitoring" forState:UIControlStateNormal];
    self.stopMonitorButton.hidden = YES;
}

- (IBAction)currentLocationButtonPressed:(UIButton *)sender {
    [self changeViewToCurrentLocation];
}

- (IBAction)getDirectionsButtonPressed:(UIButton *)sender {
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(42.36723809, -71.08061388) addressDictionary:nil];
    request.destination = [[MKMapItem alloc] initWithPlacemark:placeMark];
    request.transportType = MKDirectionsTransportTypeAny;
    request.requestsAlternateRoutes = YES;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (!error) {
            for (MKRoute *route in response.routes) {
                [self.mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
            }
        }
    }];
    
}

#pragma mark - CLLocationManager Delegates

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"I'm here!");
    UIAlertView *enterRegionAlert = [[UIAlertView alloc] initWithTitle:@"Hooray!" message:@"You're at Intrepid! #whos-here on Slack was notified." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [enterRegionAlert show];
    //[self connectToSlackWebhookWithMessage:@"I'm here!"];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"I'm not here!");
    UIAlertView *exitRegionAlert = [[UIAlertView alloc] initWithTitle:@"Boo!" message:@"You've left Intrepid! #whos-here on Slack was notified." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [exitRegionAlert show];
    //[self connectToSlackWebhookWithMessage:@"I'm not here ):"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = [locations lastObject];
    self.currentLocationButton.enabled = YES;
    [self changeViewToCurrentLocation];
}

#pragma mark - MKMapView Delegates
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        renderer.strokeColor = [UIColor blueColor];
        renderer.lineWidth = 5.0;
        return renderer;
    }
    return nil;
}

#pragma mark - public methods

- (void)connectToSlackWebhookWithMessage:(NSString *)message {
        [[slackWebhookManager sharedManager] postToSlackWithMessage:message success:^(BOOL success) {
            NSLog(@"Success? %d", success);
        } failure:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
}

- (void)changeViewToCurrentLocation {
    float spanX = .00725;
    float spanY = .00725;
    MKCoordinateRegion region;
    region.center.latitude = self.currentLocation.coordinate.latitude;
    region.center.longitude = self.currentLocation.coordinate.longitude;
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];
}

@end
