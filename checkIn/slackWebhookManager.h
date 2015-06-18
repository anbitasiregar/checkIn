//
//  slackWebhookManager.h
//  checkIn
//
//  Created by Anbita Siregar on 6/17/15.
//  Copyright (c) 2015 Anbita Siregar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface slackWebhookManager : NSObject
+ (instancetype)sharedManager;
- (void) postToSlackWithMessage: (NSString *)message success:(void (^)(BOOL success))success failure:(void (^)(NSError *error))failure;

@end
