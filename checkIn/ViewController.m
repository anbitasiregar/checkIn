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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.monitorButton.layer.cornerRadius = 5;
    self.monitorButton.layer.masksToBounds = YES;
    self.stopMonitorButton.hidden = YES;
    
    self.monitoredRegion = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(42.36723809, -71.08061388) radius:100 identifier:@"test"];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
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
    self.questionLabel.text = @"";
    self.stopMonitorButton.hidden = YES;
}

#pragma mark - CLLocationManager Delegates
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"I'm here!");
    [[slackWebhookManager sharedManager] postToSlackWithMessage:@"I'm hereeeee!!!!" success:^(BOOL success) {
        NSLog(@"Success? %d", success);
        self.questionLabel.text = @"YEP";
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"I'm not here!");
    [[slackWebhookManager sharedManager] postToSlackWithMessage:@"I'm not here ):" success:^(BOOL success) {
        NSLog(@"Success? %d", success);
        self.questionLabel.text = @"NOPE";
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
