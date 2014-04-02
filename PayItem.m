//
//  ReceivableOrPayable.m
//  MyDebt
//
//  Created by 罗若峰 on 13-6-16.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "PayItem.h"

@implementation PayItem

@synthesize payItemId,date,money,payType,name,dateString,import,createDateString;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.payItemId forKey:@"pid"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.createDateString forKey:@"createDateString"];
    [aCoder encodeFloat:self.money forKey:@"money"];
    [aCoder encodeInteger:self.payType forKey:@"payType"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.dateString forKey:@"dateString"];
    [aCoder encodeBool:self.import forKey:@"import"];    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.payItemId = [aDecoder decodeIntegerForKey: @"pid"];
        self.date = [aDecoder decodeObjectForKey: @"date"];
        self.createDateString = [aDecoder decodeObjectForKey: @"createDateString"];
        self.money = [aDecoder decodeFloatForKey: @"money"];
        self.payType = [aDecoder decodeIntegerForKey:@"payType"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.dateString = [aDecoder decodeObjectForKey:@"dateString"];
        self.import = [aDecoder decodeBoolForKey:@"import"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    PayItem *copy = [[[self class] allocWithZone:zone] init];
    copy.payItemId = self.payItemId;
    copy.date = [self.date copyWithZone:zone];
    copy.createDateString = [self.createDateString copyWithZone:zone];
    copy.money = self.money;
    copy.payType = self.payType;
    copy.name = [self.name copyWithZone:zone];
    copy.dateString = [self.dateString copyWithZone:zone];
    copy.import = self.import;
    return copy;
}

@end
