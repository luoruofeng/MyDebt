/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material,
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose.
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
 ***/
//
//  PRPSplashScreenViewController.m
//  BasicSplashScreen
//
//  Created by Matt Drance on 10/1/10.
//  Updated by Paul Warren on 1/21/11
//  Copyright 2010 Bookhouse Software, LLC. All rights reserved.
//  Copyright 2010 PrimitiveDog Software, LLC. All rights reserved.
//

#import "PRPSplashScreenViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LockViewController.h"
#import "HelpViewController.h"

@interface PRPSplashScreenViewController ()

@end

@implementation PRPSplashScreenViewController

@synthesize splashImage;
@synthesize delegate;
@synthesize delay;

- (void)showInWindow:(UIWindow *)window {
    self.window = window;
    [window addSubview:self.view];
}

- (void)viewDidLoad {
    self.view.layer.contentsScale = [[UIScreen mainScreen] scale];
    self.view.layer.contents = (id)self.splashImage.CGImage;
    self.view.contentMode = UIViewContentModeBottom;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(startApp) withObject:nil afterDelay:0.0];
}

- (UIImage *)splashImage {
    if (splashImage == nil) {
        splashImage = [UIImage imageNamed:@"Default.png"];
    }
    return splashImage;
}

-(void) startApp
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    LockViewController *lock = [[LockViewController alloc] init];
    [lock setLockPage:YES];
    
    NSString *pw =[[NSUserDefaults standardUserDefaults] stringForKey:CONFIGE_PASSWORD];
    BOOL isUsePw =[[NSUserDefaults standardUserDefaults] boolForKey:CONFIGE_USE_PASSWORD];
    [delegate splashScreenDidDisappear:nil];
    
    if(pw && isUsePw)
    {
        [self.window.rootViewController presentViewController:lock animated:NO completion:^(void){}];
    }
    
    
    BOOL firstUseApp = [USER_DEFAULTS boolForKey:FIRST_USE_APP];
    if(!firstUseApp)
    {
        [USER_DEFAULTS setBool:YES forKey:FIRST_USE_APP];
        HelpViewController *helpViewController = [[HelpViewController alloc] init];
        [self.window.rootViewController presentViewController:helpViewController animated:NO completion:^(void){}];
    }
}

@end
