//
//  SettingViewController.m
//  MyDebt
//
//  Created by 罗若峰 on 13-6-12.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "SettingViewController.h"
#import "LockViewController.h"
#import "HelpViewController.h"
#import "LocalNotificationUtil.h"
#import "ArchiveUtil.h"

@interface SettingViewController ()
@property UITableView *table;
@property UISwitch *notificationSwitch;
@property UISwitch *passwordSwitch;
@property UILabel *notificationLabel;
@property(nonatomic, retain) UIActionSheet *actionSheet;
@property(nonatomic, retain) UIDatePicker *pickerView;
@end


@implementation SettingViewController
@synthesize
    table = table,
    notificationSwitch = notificationSwitch,
    passwordSwitch = passwordSwitch,
    notificationLabel = notificationLabel,
    pickerView=pickerView,
    actionSheet=actionSheet;


- (id)init
{
    self = [super init];
    if (self) {
        self.title= @"设置";
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [table setBackgroundView:nil];
    [table setBackgroundColor:[UIColor colorWithString:@"e2e2e2"]];
    [table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:table];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [table setFrame:self.view.bounds];

}

- (void)viewDidAppear:(BOOL)animated
{
    [self initSetConfig];
}

#pragma mark 表格

#define ROW_HEIGHT 55
#define SWITCH_HEIGHT 10
#define SWITCH_WEIGHT 20

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return 2;
    }
    else if(section == 2)
    {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    //到期是否提示，提示时间
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0){
            cell.textLabel.text = @"还款通知";
            [super viewDidLoad];
            notificationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(244 - SWITCH_WEIGHT, 15, SWITCH_WEIGHT, SWITCH_HEIGHT)];

            [notificationSwitch addTarget:self action:@selector(isNotifaction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:notificationSwitch];
        }
    }

    //是否有锁，密码
    if(indexPath.section == 1)
    {
        if(indexPath.row == 0){
            cell.textLabel.text = @"启用密码";
            
            passwordSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(244 - SWITCH_WEIGHT, 15, SWITCH_WEIGHT, SWITCH_HEIGHT)];
            
            [passwordSwitch addTarget:self action:@selector(isPassword:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:passwordSwitch];
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"更改密码";
        }
    }

    //发送邮件、关于
    if(indexPath.section == 2)
    {
        if(indexPath.row == 0){
            cell.textLabel.text = @"使用帮助";
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"去评分";
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"关于";
        }
    }
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [cell setBackgroundColor:[UIColor colorWithString:@"f0f0f0"]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setOpaque:YES];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        LockViewController *lock = [[LockViewController alloc] init];
        lock.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:lock animated:YES];
    }
    
    else if(indexPath.section == 0 && indexPath.row == 1){
        //actionsheet
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定",nil];
        [actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];

        pickerView = [[UIDatePicker alloc] init];
        [pickerView setDatePickerMode:UIDatePickerModeTime];
        [pickerView setAlpha:0.7];
        NSString *notification_string = [USER_DEFAULTS stringForKey:CONFIGE_NOTIFICATION];
        
        NSDate *notification = [NSDate dateWithString:[NSString stringWithFormat:@"1999-09-09 %@",notification_string ,nil]format:@"yyyy-MM-dd HH:mm"];
        
        [pickerView setDate:notification];
        [actionSheet addSubview:pickerView];
        actionSheet.delegate = self;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    
    else if(indexPath.section == 2 && indexPath.row == 0)
    {
        [self presentModalViewController:[[HelpViewController alloc] init] animated:YES];
    }
    else if(indexPath.section == 2 && indexPath.row == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:TO_GRADE]]];
    }
    else if(indexPath.section == 2 && indexPath.row == 2)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ABOUT_ME]];
    }
}

#pragma mark 事件
-(void)isNotifaction:(id)send
{
    [USER_DEFAULTS setBool:notificationSwitch.isOn forKey:CONFIGE_USE_NOTIFICATION];
    [USER_DEFAULTS synchronize];
    
    LocalNotificationUtil *notUtil = [LocalNotificationUtil sharedLocalNotificationUtil];
    if(notificationSwitch.isOn)
    {
        NSMutableArray *payItemPayTypeArray = [NSMutableArray arrayWithObjects:DICTIONARY_PAYABLE,DICTIONARY_RECEIVABLE, nil];
        NSMutableDictionary *contentDictionary = [[ArchiveUtil shareArchiveUtil] getPayItemDictionaryByPayItemPayTypes:payItemPayTypeArray];
        
        if(contentDictionary)
        {
            NSMutableArray *recArray = [contentDictionary  objectForKey:DICTIONARY_RECEIVABLE];
            NSMutableArray *payArray = [contentDictionary  objectForKey:DICTIONARY_PAYABLE];
            
            if(recArray)
            {
                for(PayItem *item in recArray)
                {
                    [notUtil addPayItemLocalNotificationUtil:item];
                }
            }
            
            if(payArray)
            {
                for(PayItem *item in payArray)
                {
                    [notUtil addPayItemLocalNotificationUtil:item];
                }
            }
        }
    }
    else
    {
        [[LocalNotificationUtil sharedLocalNotificationUtil] cancelAllPayItemLocalNotification];
    }
}

-(void)isPassword:(id)send
{
    passwordSwitch = send;

    if(passwordSwitch.isOn)
    {
        [USER_DEFAULTS setBool:YES forKey:CONFIGE_USE_PASSWORD];
        [USER_DEFAULTS synchronize];
        
        LockViewController *lock = [[LockViewController alloc] init];
        lock.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:lock animated:YES];
    }
    else{
        [USER_DEFAULTS setBool:NO forKey:CONFIGE_USE_PASSWORD];
        
        [USER_DEFAULTS setValue:@"" forKey:CONFIGE_PASSWORD];
        [USER_DEFAULTS synchronize];
    }
    
}

-(void)initSetConfig
{
    [notificationSwitch setOn:[USER_DEFAULTS boolForKey:CONFIGE_USE_NOTIFICATION]];

    [passwordSwitch setOn:[USER_DEFAULTS boolForKey:CONFIGE_USE_PASSWORD]];
        
    [notificationLabel setText:[USER_DEFAULTS stringForKey:CONFIGE_NOTIFICATION]];
}

#pragma mark actionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [NSDate toStringWithDate:[pickerView date] format:@"HH:mm"];
        notificationLabel.text = [NSDate toStringWithDate:[pickerView date] format:@"HH:mm"];
    }
    
    [USER_DEFAULTS setValue:notificationLabel.text forKey:CONFIGE_NOTIFICATION];
    [USER_DEFAULTS synchronize];
}

@end
