//
//  ArchiveUtil.h
//  MyDebt
//
//  Created by 罗若峰 on 13-9-6.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayItem.h"

@interface ArchiveUtil : NSObject<NSCopying>

+(ArchiveUtil *)shareArchiveUtil;

-(NSMutableArray *)getPayItemArrayByPayItemPayType:(NSString *)key;

-(NSMutableDictionary *)getPayItemDictionaryByPayItemPayTypes:(NSMutableArray *)payItemPayTypes;

-(PayItem *)savePayItem:(PayItem *)payItem;

-(PayItem *)updatePayItem:(PayItem *)aPayItem whichIndexOfArray:(NSInteger)index inArrayKey:(NSString *)key;

-(PayItem *)movePayItem:(NSInteger)payItemIndex fromPayItemPayTypeKey:(NSString *)fromPayItemPayTypeKey toPayItemPayTypeKey:(NSString *)toPayItemPayTypeKey;

-(PayItem *)deletePayItemIndex:(NSInteger)index fromArrayKey:(NSString *)key;

-(void)importIndexOfArray:(NSInteger)index inArrayKey:(NSString *)key;

-(PayItem *)getPayItemIndexOfArray:(NSInteger)index FromArrayKey:(NSString *)key;

-(NSMutableDictionary *) getImportPayItemDictionary;

@end
