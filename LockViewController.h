//
//  LockViewController.h
//  MyDebt
//
//  Created by 罗若峰 on 13-8-30.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigDelegate.h"

@protocol LockViewControllerDelegate <NSObject>
@optional
- (void)lockViewDidDisappear;
@end

@interface LockViewController : UIViewController

@property(nonatomic,getter = isLockPage) BOOL lockPage;

@property(nonatomic,retain) UIViewController *contentViewController;

-(IBAction)keyBoradButtonDown:(id)sender;


@end
