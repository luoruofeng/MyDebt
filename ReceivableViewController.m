//
//  BaseViewController.m
//  MyDebt
//
//  Created by 罗若峰 on 13-6-12.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "ReceivableViewController.h"
#import "PayTableViewController.h"
#import "CustomViewController.h"
#import "UIColor+ColorUtils.h"
#import "AddViewController.h"

@interface ReceivableViewController ()

@end

@implementation ReceivableViewController

- (id)init
{
    self = [super init];
    if(!self)
        return nil;

    self.title = @"我应收";
    self.titlesForHeader = [NSMutableArray arrayWithObjects:@"未收",@"已收", nil];
    return self;
}

- (void)loadView
{
    [super loadView];
    [super setPayItemPayType:DICTIONARY_RECEIVABLE];
    [super setPayItemPayTypeDid:DICTIONARY_RECEIVABLE_DID];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    //新增添加按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSubview)];
    
    //设置添加按钮颜色
    if([self.navigationItem.rightBarButtonItem respondsToSelector:@selector(setTintColor:)])
        self.navigationItem.rightBarButtonItem.tintColor = [[UIColor alloc] initWithString:@"#9A00E3"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 按钮事件
- (void)addReceivable:(UIBarButtonItem *)button
{
    
}

- (void)addSubview
{
    AddViewController *addViewControllerd = [[AddViewController alloc] init];
    addViewControllerd.title = @"新增";
    [addViewControllerd setPayItemPayType:PayItemPayTypeReceivable];
    [addViewControllerd setUpdate:NO];
    [self.navigationController pushViewController:addViewControllerd animated:YES];
}

@end
