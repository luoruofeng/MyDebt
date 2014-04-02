//
//  CustomTableViewController.h
//  MyDebt
//
//  Created by 罗若峰 on 13-6-16.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTableViewController : UITableViewController

@property (nonatomic,retain) NSMutableDictionary *types;
@property (nonatomic,retain) NSMutableArray *paies;
@property (nonatomic,retain) NSMutableArray *titlesForHeader;
@property (nonatomic,copy) NSString *payItemPayType;
@property (nonatomic,copy) NSString *payItemPayTypeDid;

@end
