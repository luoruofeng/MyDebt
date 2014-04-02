//
//  UIPurpletextFieldDelegate.m
//  MyDebt
//
//  Created by 罗若峰 on 13-8-11.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "UIPurpletextFieldDelegate.h"
#import "AddViewController.h"
#import "UIPurpleTextField.h"

@implementation UIPurpletextFieldDelegate

@synthesize uiTextField=uiTextField;

-(id)initWithTextField
{
    self = [super init];
    if(self != nil)
    {
    }
    return self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = [[UIColor colorWithString:@"#9100e3"] CGColor];
    textField.textColor = [UIColor colorWithString:@"#9100e3"];

    UIViewController *viewController = [self.uiTextField viewController];
    
    if([viewController isKindOfClass:[AddViewController class]])
    {
        AddViewController *superView = (AddViewController *)viewController;
        [superView  moveScrollByText:textField];
        
        if(textField.tag == 3)
        {
            [superView showDatePicker];
        }
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

@end
