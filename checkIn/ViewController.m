//
//  ViewController.m
//  checkIn
//
//  Created by Anbita Siregar on 6/17/15.
//  Copyright (c) 2015 Anbita Siregar. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController()
@property (strong, nonatomic) CLCircularRegion *monitoredRegion;
//@property (strong, nonatomic) UILocalNotification *localNotification;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.monitoredRegion = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(42.36723809, -71.08061388) radius:100 identifier:@"test"];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }

    UILocalNotification *localNotification;
    localNotification = [[UILocalNotification alloc] init];
    localNotification.region = self.monitoredRegion;
    localNotification.alertBody = @"I'm here!";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
}

#pragma mark - UIButton Delegates
- (IBAction)monitorButtonPressed:(UIButton *)sender {
    [self.locationManager startMonitoringForRegion:self.monitoredRegion];
}
- (IBAction)stopMonitorButtonPressed:(UIButton *)sender {
    [self.locationManager stopMonitoringForRegion:self.monitoredRegion];
}

#pragma mark - CLLocationManager Delegates
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"I'm here!");
}

@end
