//
//  UIPurpletextFieldDelegate.h
//  MyDebt
//
//  Created by 罗若峰 on 13-8-11.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIPurpleTextField;

@interface UIPurpletextFieldDelegate : NSObject<UITextFieldDelegate>
 @property(nonatomic,retain) UIPurpleTextField *uiTextField;
@end
