//
//  PurpleTextField.m
//  MyDebt
//
//  Created by 罗若峰 on 13-8-4.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "UIPurpleTextField.h"
#import "AddViewController.h"
#import "UIPurpletextFieldDelegate.h"

@implementation UIPurpleTextField

- (id)init:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(25, 85, 250, 35)];
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = [UIColor colorWithString:@"#e9e9e9"];
        self.textColor = [UIColor colorWithString:@"#333333"];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [[UIColor colorWithString:@"#c0c0c0"] CGColor];
        self.layer.borderWidth = 1.3;
        self.font = [UIFont boldSystemFontOfSize:15];
        [self setClipsToBounds: YES];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return self;
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
