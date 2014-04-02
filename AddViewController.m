//
//  AddViewController.m
//  MyDebt
//
//  Created by 罗若峰 on 13-7-28.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "AddViewController.h"
#import "UIColor+ColorUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "UIPurpleTextField.h"
#import "UIPurpletextFieldDelegate.h"
#import "ArchiveUtil.h"
#import "PayableViewController.h"
#import "ReceivableViewController.h"
#import "LocalNotificationUtil.h"

@interface UIScrollView  (touch)
@end

@implementation UIScrollView  (touch)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event];
}
@end


@interface AddViewController ()
   @property(nonatomic,retain)  UIPurpleTextField *moneyText;
   @property(nonatomic,retain)  UIPurpleTextField *dateText;
   @property(nonatomic,retain)  UIPurpleTextField *nameText;
    @property(nonatomic,retain)  UIButton *saveButton;
    @property(nonatomic,retain)  UIScrollView *scrollView;
    @property(nonatomic, retain) UIDatePicker *pickerView;
    @property(nonatomic, retain) UIActionSheet *actionSheet;
@end

@implementation AddViewController

@synthesize navTitle = navTitle,doneInKeyboardButton=doneInKeyboardButton,moneyText=moneyText,dateText=dateText,nameText=nameText,scrollView=scrollView,saveButton=saveButton,pickerView=pickerView,actionSheet=actionSheet,payItemPayType=payItemPayType,aPayItem=aPayItem,arrayKey=arrayKey,indexOfArray=indexOfArray;

- (id)init
{
    self = [super init];
    if (self) {
        self.navigationController.title = navTitle;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [super viewDidLoad];
    
    //设置scroll
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    scrollView.tag = 100;
    
    self.view.backgroundColor = [UIColor colorWithString:@"#e2e2e2"];
    
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
    backgroundView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
    backgroundView.layer.borderColor = [[UIColor colorWithString:@"#c0c0c0"] CGColor];
    backgroundView.layer.borderWidth = 1.3;
    backgroundView.layer.shadowOffset = CGSizeMake(10, 10);
    backgroundView.layer.shadowColor = [[UIColor colorWithString:@"#747474"] CGColor];
    
    //新增
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 25, 300, 25)];
    addLabel.font = [UIFont boldSystemFontOfSize:20];
    addLabel.text = @"新增";
    addLabel.backgroundColor = [UIColor clearColor];
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 60, 250, 20)];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.text = @"姓名";
    nameLabel.backgroundColor = [UIColor clearColor];
    
    nameText = [[UIPurpleTextField alloc] initWithFrame:CGRectMake(25, 85, 250, 35)];
    nameText.keyboardType = UIKeyboardTypeDefault;
    nameText.placeholder = @"请输入姓名";
    nameText.tag = 1;

    nameText.delegate = self;
    
    
    //金额
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 130, 250, 20)];
    moneyLabel.font = [UIFont boldSystemFontOfSize:15];
    moneyLabel.text = @"金额";
    moneyLabel.backgroundColor = [UIColor clearColor];
    
    moneyText = [[UIPurpleTextField alloc] initWithFrame:CGRectMake(25, 155, 250, 35)];
    moneyText.keyboardType = UIKeyboardTypeNumberPad;
    moneyText.placeholder = @"请输入金额";
    moneyText.tag = 2;
    
    moneyText.delegate = self;
    
    
    //日期
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 200, 250, 20)];
    dateLabel.font = [UIFont boldSystemFontOfSize:15];
    dateLabel.text = @"日期";
    dateLabel.backgroundColor = [UIColor clearColor];
    
    dateText = [[UIPurpleTextField alloc] initWithFrame:CGRectMake(25, 225, 250, 35)];
    dateText.keyboardType = UIKeyboardTypeDefault;
    dateText.placeholder = @"请输入还款日期";
    dateText.tag =3;
    dateText.delegate = self;
    
    //保存
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(10, [[UIScreen mainScreen] bounds].size.height - 120, 300, 40);
    [saveButton setBackgroundImage:[UIImage imageNamed:@"saveButton"] forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"saveButtonDown"] forState:UIControlStateHighlighted];
    saveButton.layer.cornerRadius = 8;
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.borderColor = [[UIColor colorWithString:@"#070707"] CGColor];
    saveButton.layer.borderWidth = 1.3;
    [saveButton addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [backgroundView addSubview:addLabel];
    
    [backgroundView addSubview:nameLabel];
    [backgroundView addSubview:nameText];
    
    [backgroundView addSubview:moneyLabel];
    [backgroundView addSubview:moneyText];
    
    [backgroundView addSubview:dateLabel];
    [backgroundView addSubview:dateText];
    
    [scrollView addSubview:backgroundView];
    
    [scrollView addSubview:saveButton];
    
    [self.view addSubview:scrollView];
    
    
    //actionsheet
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定",nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    
    pickerView = [[UIDatePicker alloc] init];
    
    [pickerView setBackgroundColor:[UIColor clearColor]];
    [pickerView setAlpha:0.7];
    
    [pickerView setMinimumDate:[NSDate date]];
    [pickerView setDatePickerMode:UIDatePickerModeDateAndTime];
    [actionSheet addSubview:pickerView];
    actionSheet.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated
{
    if([self isUpdate])
    {
        [moneyText setText:[NSString stringWithFormat:@"%.0f",aPayItem.money,nil]];
        [dateText setText:aPayItem.dateString];
        [nameText setText:aPayItem.name];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (![dateText isExclusiveTouch] && ![moneyText isExclusiveTouch] && ![nameText isExclusiveTouch]) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark 操作

-(void)errorAlertString:(NSString *)alert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alert message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void) saveInfo
{
    PayItem *item = aPayItem;
    if(!item)
    {
        item = [[PayItem alloc] init];
    }
    NSString *moneyValue = [(UITextView *)[self.view viewWithTag:2] text];
    NSString *nameValue = [(UITextView *)[self.view viewWithTag:1] text];
    NSString *dateValue = [(UITextView *)[self.view viewWithTag:3] text];
    
    if(!nameValue || [nameValue isEqual:@""])
    {
        [self errorAlertString:@"姓名未填写"];
        return;
    }
    if(!moneyValue || [moneyValue isEqual:@""])
    {
        [self errorAlertString:@"金额未填写"];
        return;
    }
    if(!dateValue || [dateValue isEqual:@""])
    {
        [self errorAlertString:@"日期未填写" ];
        return;
    }
    
    //插入蒙版
    UIView *overlay = [[UIView alloc] initWithFrame:APPLICATION_FRAME];
    [overlay setBackgroundColor:[UIColor colorWithString:@"#999999"]];
    [overlay setAlpha:0.5];
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32.0f, 32.0f)];
    [activity setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activity startAnimating];
    [overlay addSubview:activity];
    [overlay setUserInteractionEnabled:YES];
    [KEY_WINDOW addSubview:overlay];
    
    [item setMoney:[moneyValue floatValue]];
    [item setName:nameValue];
    [item setDateString:dateValue];
    
    ArchiveUtil *archive = [ArchiveUtil shareArchiveUtil];
    if([self isUpdate])
    {
        item = [archive updatePayItem:item whichIndexOfArray:indexOfArray inArrayKey:arrayKey];
    }
    else
    {
        NSString *nowString = [NSDate toStringWithDate:[NSDate date] format:@"yyyy-MM-dd HH:mm"];
        [item setCreateDateString:nowString];
        [item setPayType:self.payItemPayType];
        item = [archive savePayItem:item];
    }
    
    [[LocalNotificationUtil sharedLocalNotificationUtil] addPayItemLocalNotificationUtil:item];
    
    [self.navigationController popToViewController:[[[self navigationController] viewControllers] objectAtIndex:0] animated:YES];
    
    //去掉蒙版
    [activity stopAnimating];
    [overlay removeFromSuperview];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}



#pragma mark 键盘
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if(height > 0)
    {
        scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + height + 44);
    }
}

-(void)finishAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
}

-(void) hideDoneButton:(UITextField *)currentFiled
{
    if(currentFiled.keyboardType == UIKeyboardTypeNumberPad)
    {
        [doneInKeyboardButton setHidden:NO];
    }
    else
    {
        [doneInKeyboardButton setHidden:YES];
    }
}

- (void)moveScrollByText:(UITextField *) text
{
    CGRect textRectOnWindow = [self.view convertRect:text.frame toView:KEY_WINDOW];
    CGPoint movedPoint = CGPointMake(0,   textRectOnWindow.origin.y - 20 - 44 - 25 );
    [scrollView setContentOffset:movedPoint  animated:YES];
}

-(void)showDatePicker
{
    [actionSheet showInView:self.view];
    
}

#pragma mark text-delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = [[UIColor colorWithString:@"#9100e3"] CGColor];
    textField.textColor = [UIColor colorWithString:@"#9100e3"];
    
        [self  moveScrollByText:textField];
        
        if(textField.tag == 3)
        {
            
            [self showDatePicker];
        }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = [[UIColor colorWithString:@"#c0c0c0"] CGColor];
    textField.textColor = [UIColor colorWithString:@"#333333"];
    
    if(textField.tag == 3)
    {
        [textField resignFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    
    if(textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        if ([string length] > 0) {
            return [textField.text length] < 10;
        }
    }
    else
    {
        if ([string length] > 0) {
            return [textField.text length] < 25;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    if(textField.tag == 1 || textField.tag == 2){
        [[textField.superview viewWithTag:textField.tag+1] becomeFirstResponder];
    }
    return YES;
}


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController)
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

#pragma mark actionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        dateText.text = [NSDate toStringWithDate:[pickerView date] format:@"yyyy-MM-dd HH:mm"];
    }
    
    [self textFieldDidEndEditing:dateText];
    
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);

}

@end
