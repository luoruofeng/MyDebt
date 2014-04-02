//
//  LocalNotifactionUtil.h
//  MyDebt
//
//  Created by 罗若峰 on 13-9-13.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayItem.h"

@interface LocalNotificationUtil : NSObject

+ (LocalNotificationUtil *) sharedLocalNotificationUtil;

- (void) addPayItemLocalNotificationUtil:(PayItem *)payItem;

- (void) cancelPayItemLocalNotificationUtilByPayItemId:(NSInteger)id;

- (void) cancelAllPayItemLocalNotification;

- (void)minusIconBadgeNumber;
@end
