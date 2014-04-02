//
//  LocalNotifactionUtil.m
//  MyDebt
//
//  Created by 罗若峰 on 13-9-13.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "LocalNotificationUtil.h"
#import "PayItem.h"

static LocalNotificationUtil *localNotificationUtil = nil;
static int iconBadgeNumber = 0;
@implementation LocalNotificationUtil

+ (LocalNotificationUtil *) sharedLocalNotificationUtil
{
    @synchronized(self)
    {
        if(localNotificationUtil == nil)
        {
            localNotificationUtil = [[LocalNotificationUtil alloc] init];
        }
    }
    return localNotificationUtil;
}

- (void) addPayItemLocalNotificationUtil:(PayItem *)payItem
{
    if(![USER_DEFAULTS boolForKey:CONFIGE_USE_NOTIFICATION])
    {
        return;
    }
    
    [self cancelPayItemLocalNotificationUtilByPayItemId:payItem.payItemId];
    
    if(payItem.payType == PayItemPayTypeReceivableDid || payItem.payType == PayItemPayTypePayableDid)
    {
        return;
    }
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];

    if(payItem.payType == PayItemPayTypePayable)
    {
        [localNotification setAlertBody:[NSString stringWithFormat:@"我该还 %@ ￥%.0f 元!",payItem.name,payItem.money,nil]];
    }
    else if(payItem.payType == PayItemPayTypeReceivable)
    {
        [localNotification setAlertBody:[NSString stringWithFormat:@"%@ 该还我  ￥%.0f 元!",payItem.name,payItem.money,nil]];
    }
    
    [localNotification setFireDate:payItem.date];
    [localNotification setSoundName:UILocalNotificationDefaultSoundName];
    iconBadgeNumber++;
    [localNotification setApplicationIconBadgeNumber:iconBadgeNumber];
    
    NSDictionary *userinfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:payItem.payItemId] forKey:@"id"];
    [localNotification setUserInfo:userinfo];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void) cancelAllPayItemLocalNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    iconBadgeNumber = 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = iconBadgeNumber;

}

- (void) cancelPayItemLocalNotificationUtilByPayItemId:(NSInteger)id
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifications ) {
        if( [(NSNumber *)[notification.userInfo objectForKey:@"id"] integerValue] == id) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            iconBadgeNumber = 0;
            [UIApplication sharedApplication].applicationIconBadgeNumber = iconBadgeNumber;
            break;
        }
    }
}

- (void)minusIconBadgeNumber
{
    iconBadgeNumber--;
    [UIApplication sharedApplication].applicationIconBadgeNumber = iconBadgeNumber;
}

@end
