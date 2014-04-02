//
//  ReceivableOrPayable.h
//  MyDebt
//
//  Created by 罗若峰 on 13-6-16.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayItem : NSObject<NSCoding,NSCopying>

@property (nonatomic) NSInteger payItemId;

@property (nonatomic) PayItemPayType payType;

@property (nonatomic,retain) NSString *dateString;

@property (nonatomic,retain) NSDate *date;

@property (nonatomic,retain) NSString *createDateString;

@property (nonatomic) CGFloat money;

@property (nonatomic,retain) NSString *name;

@property (nonatomic) BOOL import;

@end
