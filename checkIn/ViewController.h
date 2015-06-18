//
//  ViewController.h
//  checkIn
//
//  Created by Anbita Siregar on 6/17/15.
//  Copyright (c) 2015 Anbita Siregar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *monitorButton;
@property (weak, nonatomic) IBOutlet UIButton *stopMonitorButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

