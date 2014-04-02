//
//  AddViewController.h
//  MyDebt
//
//  Created by 罗若峰 on 13-7-28.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayItem;

@interface AddViewController : UIViewController<UITextFieldDelegate ,UIActionSheetDelegate>

@property (nonatomic,retain) NSString *navTitle;

@property (nonatomic)PayItemPayType payItemPayType;

@property (nonatomic,retain) UIButton *doneInKeyboardButton;

@property (nonatomic,getter = isUpdate) BOOL update;

@property (nonatomic,retain) NSString *arrayKey;

@property (nonatomic,retain) PayItem *aPayItem;

@property (nonatomic) NSInteger indexOfArray;

- (void)moveScrollByText:(UITextField *) text;
-(void)showDatePicker;
@end
