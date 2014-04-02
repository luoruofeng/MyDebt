//
//  ArchiveUtil.m
//  MyDebt
//
//  Created by 罗若峰 on 13-9-6.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "ArchiveUtil.h"
#import "PayItem.h"

static ArchiveUtil *archiveUtil = nil;
static NSMutableDictionary *rootMutableDictionary = nil;
static NSString *path = nil;


@implementation ArchiveUtil

#pragma mark --单例

+(ArchiveUtil *)shareArchiveUtil
{
    @synchronized(self){
        if(archiveUtil == nil)
        {
            archiveUtil = [[[self class] alloc] init];
            
            NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex: 0];
            path = [homePath stringByAppendingPathComponent:@"data.archive"];
            
            NSDictionary *rootDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            if(!rootDictionary || rootDictionary.count < 1)
            {
                NSMutableArray *receivableArray = [[NSMutableArray alloc] init];
                NSMutableArray *payableArray = [[NSMutableArray alloc] init];
                NSMutableArray *receivableDidArray = [[NSMutableArray alloc] init];
                NSMutableArray *payableDidArray = [[NSMutableArray alloc] init];
                
                rootMutableDictionary = [[NSMutableDictionary alloc] init];
                
                [rootMutableDictionary setValue:payableArray forKey:DICTIONARY_PAYABLE];
                [rootMutableDictionary setValue:receivableArray forKey:DICTIONARY_RECEIVABLE];
                [rootMutableDictionary setValue:receivableDidArray forKey:DICTIONARY_RECEIVABLE_DID];
                [rootMutableDictionary setValue:payableDidArray forKey:DICTIONARY_PAYABLE_DID];
            }
            else
            {
                rootMutableDictionary = [NSMutableDictionary dictionaryWithDictionary:rootDictionary];
            }
        }
    }
    return archiveUtil;
}

+ (id)allocWithZone:(NSZone *)zone
{
    if(archiveUtil == nil)
    {
        archiveUtil = [super allocWithZone:zone];
    }
    return archiveUtil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return archiveUtil;
}

#pragma mark --方法

-(NSMutableArray *)getPayItemArrayByPayItemPayType:(NSString *)key
{
   NSMutableArray *payItemsArray = [self getArrayByKey:key];
   
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    if(payItemsArray && payItemsArray.count > 0)
    {
        [result addObjectsFromArray:payItemsArray];
    }
    return result;
}

-(NSMutableDictionary *)getPayItemDictionaryByPayItemPayTypes:(NSMutableArray *)payItemPayTypes
{
    if(!payItemPayTypes || payItemPayTypes.count < 1)
    {
        return nil;
    }
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in payItemPayTypes) {
        NSMutableArray *reverseArray = [self getPayItemArrayByPayItemPayType:key];
        [result setObject:reverseArray forKey:key];
    }
    
    return result;
}

-(PayItem *)savePayItem:(PayItem *)payItem
{
    NSMutableArray *payItemsArray = nil;
    NSString *subDictionaryKey = nil;
    if(payItem.payType == PayItemPayTypePayable)
    {
        subDictionaryKey = DICTIONARY_PAYABLE;
    }
    else if(payItem.payType == PayItemPayTypeReceivable)
    {
        subDictionaryKey = DICTIONARY_RECEIVABLE;
    }
    payItemsArray = [self getArrayByKey:subDictionaryKey];
    [payItem setPayItemId:[self getNewId]];
    [payItem setDate:[self getDateFromString:payItem.dateString]];
    [payItem setImport:NO];
    [payItemsArray insertObject:payItem atIndex:0];
    [rootMutableDictionary setValue:payItemsArray forKey:subDictionaryKey];
    [NSKeyedArchiver archiveRootObject:rootMutableDictionary toFile:path];
    
    return payItem;
}

-(PayItem *)updatePayItem:(PayItem *)aPayItem whichIndexOfArray:(NSInteger)index inArrayKey:(NSString *)key
{
    PayItem *currentPayItem = [self getPayItemIndexOfArray:index FromArrayKey:key];
    if(aPayItem.name)
    {
        [currentPayItem setName:aPayItem.name];
    }
    if(aPayItem.money)
    {
        [currentPayItem setMoney:aPayItem.money];
    }
    if(aPayItem.dateString)
    {
        NSDate *newDate = [self getDateFromString:aPayItem.dateString];
        [currentPayItem setDate:newDate];
        [currentPayItem setDateString:aPayItem.dateString];
    }
    if(aPayItem.import)
    {
        [currentPayItem setImport:aPayItem.import];
    }
    
    [NSKeyedArchiver archiveRootObject:rootMutableDictionary toFile:path];
    
    return currentPayItem;
}

-(PayItem *)movePayItem:(NSInteger)payItemIndex fromPayItemPayTypeKey:(NSString *)fromPayItemPayTypeKey toPayItemPayTypeKey:(NSString *)toPayItemPayTypeKey
{
   NSMutableArray *fromArray = [self getArrayByKey:fromPayItemPayTypeKey];
   NSMutableArray *toArray = [self getArrayByKey:toPayItemPayTypeKey];
    
    PayItem *fromPayItem = [fromArray objectAtIndex:payItemIndex];
    
    if([toPayItemPayTypeKey isEqualToString:DICTIONARY_PAYABLE])
        [fromPayItem setPayType:PayItemPayTypePayable];
    if([toPayItemPayTypeKey isEqualToString:DICTIONARY_PAYABLE_DID])
        [fromPayItem setPayType:PayItemPayTypePayableDid];
    if([toPayItemPayTypeKey isEqualToString:DICTIONARY_RECEIVABLE])
        [fromPayItem setPayType:PayItemPayTypeReceivable];
    if([toPayItemPayTypeKey isEqualToString:DICTIONARY_RECEIVABLE_DID])
        [fromPayItem setPayType:PayItemPayTypeReceivableDid];

    [toArray insertObject:fromPayItem atIndex:0];
    [fromArray removeObjectAtIndex:payItemIndex];
    
    [rootMutableDictionary setValue:fromArray forKey:fromPayItemPayTypeKey];
    [rootMutableDictionary setValue:toArray forKey:toPayItemPayTypeKey];
    [NSKeyedArchiver archiveRootObject:rootMutableDictionary toFile:path];
    return  fromPayItem;
}

-(PayItem *)deletePayItemIndex:(NSInteger)index fromArrayKey:(NSString *)key
{
    NSMutableArray *currentArray = [self getArrayByKey:key];
    PayItem *result = [currentArray objectAtIndex:index];
    [currentArray removeObjectAtIndex:index];
    
    [NSKeyedArchiver archiveRootObject:rootMutableDictionary toFile:path];
    return result;
}

#pragma mark ----该类公用方法

-(NSMutableArray *)getArrayByKey:(NSString *)key
{
    id objArray = [rootMutableDictionary objectForKey:key];
    if([objArray isKindOfClass:[NSMutableArray class]])
    {
        return objArray;
    }
    else if([objArray isKindOfClass:[NSArray class]])
    {
        return [NSMutableArray arrayWithArray:objArray];
    }
    return nil;
}

-(NSMutableDictionary *)getSubDictionaryByKey:(NSString *)key
{
    id objSubDictionary = [rootMutableDictionary objectForKey:key];
    if([objSubDictionary isKindOfClass:[NSMutableDictionary class]])
    {
        return objSubDictionary;
    }
    else if([objSubDictionary isKindOfClass:[NSDictionary class]])
    {
        return [NSMutableDictionary dictionaryWithDictionary:objSubDictionary];
    }
    return nil;
}

-(NSInteger)getNewId
{
    NSInteger currentId =  [USER_DEFAULTS integerForKey:CURRENT_MAX_PAY_ITEM_ID];
    if(!currentId && currentId != 0)
    {
        [USER_DEFAULTS setInteger:0 forKey:CURRENT_MAX_PAY_ITEM_ID];
        [USER_DEFAULTS synchronize];
        return 0;
    }
    else
    {
        currentId++;
        [USER_DEFAULTS setInteger:currentId forKey:CURRENT_MAX_PAY_ITEM_ID];
        [USER_DEFAULTS synchronize];
        return currentId;
    }
}

-(NSDate *)getDateFromString:(NSString *)string
{
    return [NSDate dateWithString:string format:@"yyyy-MM-dd HH:mm"];
}

-(void)importIndexOfArray:(NSInteger)index inArrayKey:(NSString *)key
{
    PayItem *currentPayItem = [self getPayItemIndexOfArray:index FromArrayKey:key];
    [currentPayItem setImport:!currentPayItem.import];
    [NSKeyedArchiver archiveRootObject:rootMutableDictionary toFile:path];
}

-(PayItem *)getPayItemIndexOfArray:(NSInteger)index FromArrayKey:(NSString *)key
{
    NSMutableArray *currentArray = [self getArrayByKey:key];
    return [currentArray objectAtIndex:index];
}

-(NSMutableDictionary *)getImportPayItemDictionary
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *receivableArray = [self getPayItemArrayByPayItemPayType:DICTIONARY_RECEIVABLE];
    NSMutableArray *receivableDidArray = [self getPayItemArrayByPayItemPayType:DICTIONARY_RECEIVABLE_DID];
    [self importInArray:receivableArray];
    [self importInArray:receivableDidArray];
    NSArray *allReceivableArray = [receivableArray arrayByAddingObjectsFromArray:receivableDidArray];
    
    NSMutableArray *payableArray = [self getPayItemArrayByPayItemPayType:DICTIONARY_PAYABLE];
    NSMutableArray *payableDidArray = [self getPayItemArrayByPayItemPayType:DICTIONARY_PAYABLE_DID];
    [self importInArray:payableArray];
    [self importInArray:payableDidArray];
    NSArray *allPayableArray = [receivableArray arrayByAddingObjectsFromArray:receivableDidArray];
    
    [result setObject:allReceivableArray forKey:DICTIONARY_ALL_RECEIVABLE];
    [result setObject:allPayableArray forKey:DICTIONARY_ALL_PAYABLE];    
    return result;
}

-(NSMutableArray *)importInArray:(NSMutableArray *)array
{
    if(array)
    {
        for(PayItem *item in array)
        {
            if(!item.import || item.import == NO)
                [array removeObject:item];
        }
    }
    return array;
}

@end
