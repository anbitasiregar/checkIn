//
//  slackWebhookManager.m
//  checkIn
//
//  Created by Anbita Siregar on 6/17/15.
//  Copyright (c) 2015 Anbita Siregar. All rights reserved.
//

#import "slackWebhookManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation slackWebhookManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    
    static id shared = nil;
    
    dispatch_once(&onceToken, ^{
        shared = [slackWebhookManager new];
    });
    return shared;
}

- (void) postToSlackWithMessage: (NSString *)message success:(void (^)(BOOL success))success failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{@"text": message, @"username":@"anbitasiregar"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:@"https://hooks.slack.com/services/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" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success!");
        success(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

@end
