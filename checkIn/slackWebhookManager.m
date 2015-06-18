//
//  slackWebhookManager.m
//  checkIn
//
//  Created by Anbita Siregar on 6/17/15.
//  Copyright (c) 2015 Anbita Siregar. All rights reserved.
//

#import "slackWebhookManager.h"

@implementation slackWebhookManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    
    static id shared = nil;
    
    dispatch_once(&onceToken, ^{
        shared = [slackWebhookManager new];
    });
    return shared;
}

- (void) postToSlackWithMessage: (NSString *)message {
    NSString *urlString = @"https://slack.com/api/POST";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
}

@end
