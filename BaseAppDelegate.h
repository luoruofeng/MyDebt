//
//  BaseAppDelegate.h
//  MyDebt
//
//  Created by 罗若峰 on 13-6-12.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRPSplashScreenViewController.h"

@class ReceivableViewController;

@interface BaseAppDelegate : UIResponder <UIApplicationDelegate,PRPSplashScreenViewControllerDelegate,LockViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ReceivableViewController *viewController;

@property (nonatomic, retain) PRPSplashScreenViewController *splashController;
@end
