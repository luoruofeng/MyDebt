//
//  BaseAppDelegate.m
//  MyDebt
//
//  Created by 罗若峰 on 13-6-12.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "BaseAppDelegate.h"

#import "ReceivableViewController.h"
#import "PayableViewController.h"
#import "MyNavigation.h"
#import "SettingViewController.h"
#import "PeopleViewController.h"
#import "LocalNotificationUtil.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation BaseAppDelegate

SystemSoundID mysound;

@synthesize splashController;

- (UIViewController *)addSplashScreen {
	
    splashController = [[PRPSplashScreenViewController alloc] init];
	self.splashController.delegate = self;
	self.splashController.delay = 5.0;
    [self.splashController showInWindow:self.window];
    return splashController;
}

- (void)splashScreenDidDisappear:(PRPSplashScreenViewController *)splashScreen
{
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if(IOS_VERSION >= 7.0)
    {
        [backgroundImage setImage:[UIImage imageNamed:@"background_grey"]];
    }
    else
    {
        [backgroundImage setImage:[UIImage imageNamed:@"background"]];
    }
    
    [self.window addSubview:backgroundImage];
    self.window.rootViewController = [self setView];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self registerDefaults];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = [self addSplashScreen];
    [self.window makeKeyAndVisible];
    
    // create the sound
	NSString *sndpath = [[NSBundle mainBundle] pathForResource:@"empty" ofType:@"wav"];
	CFURLRef baseURL = (__bridge CFURLRef)[NSURL fileURLWithPath:sndpath];
	
	// Identify it as not a UI Sound
    AudioServicesCreateSystemSoundID(baseURL, &mysound);
	AudioServicesPropertyID flag = 0;  // 0 means always play
	AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(SystemSoundID), &mysound, sizeof(AudioServicesPropertyID), &flag);
    [self playSound];
    sndpath = [[NSBundle mainBundle] pathForResource:@"basicsound" ofType:@"wav"];
	baseURL = (__bridge CFURLRef)[NSURL fileURLWithPath:sndpath];
	
	// Identify it as not a UI Sound
    AudioServicesCreateSystemSoundID(baseURL, &mysound);
    flag = 0;  // 0 means always play
	AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(SystemSoundID), &mysound, sizeof(AudioServicesPropertyID), &flag);
    
    return YES;
}

- (void)registerDefaults {
    NSString *prefs = [[NSBundle mainBundle] pathForResource:@"init_config" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:prefs];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UITabBarController *)setView
{
    if(IOS_VERSION >= 7.0){
        [KEY_WINDOW setTintColor:[UIColor colorWithString:@"9a00e3"]];
    }
    //view controllers
    ReceivableViewController *receivable = [[ReceivableViewController alloc] init];
    MyNavigation *receivableNav = [[MyNavigation alloc] initWithRootViewController:receivable];
    
    UITabBarItem *receivableTabBar = [[UITabBarItem alloc] initWithTitle:@"我应收" image:[UIImage imageNamed:@"receivable"] tag:1];
    receivableNav.tabBarItem = receivableTabBar;
    
    PayableViewController *payable = [[PayableViewController alloc] init];
    MyNavigation *payableNav = [[MyNavigation alloc] initWithRootViewController:payable];
    UITabBarItem *payableTabBar = [[UITabBarItem alloc] initWithTitle:@"我应付" image:[UIImage imageNamed:@"payable"] tag:2];
    payableNav.tabBarItem = payableTabBar;
    
    SettingViewController *setting = [[SettingViewController alloc] init];
    MyNavigation *settingNav = [[MyNavigation alloc] initWithRootViewController:setting];
    UITabBarItem *settingTabBar = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"setting"] tag:3];
    settingNav.tabBarItem = settingTabBar;
    
    UITabBarController *tabbar = [[UITabBarController alloc] init];

    NSArray *tabbarsArray = [NSArray arrayWithObjects:receivableNav,payableNav,settingNav, nil];
    
    [tabbar setViewControllers:tabbarsArray];
    return tabbar;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)lockViewDidDisappear
{
     
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSString *pw =[[NSUserDefaults standardUserDefaults] stringForKey:CONFIGE_PASSWORD];
    BOOL isUsePw =[[NSUserDefaults standardUserDefaults] boolForKey:CONFIGE_USE_PASSWORD];
    
    if(isUsePw && pw)
    {
        LockViewController *lock = [[LockViewController alloc] init];
        [lock setLockPage:YES];
    
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:lock animated:NO completion:^(void){}];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[LocalNotificationUtil sharedLocalNotificationUtil] cancelAllPayItemLocalNotification];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark ----本地通知

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //调用声音
    [self playSound];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    [[LocalNotificationUtil sharedLocalNotificationUtil] minusIconBadgeNumber];
}

#pragma mark ---播放声音
- (void)playSound
{
    if ([MPMusicPlayerController iPodMusicPlayer].playbackState ==  MPMusicPlaybackStatePlaying)
		AudioServicesPlayAlertSound(mysound);
	else
		AudioServicesPlaySystemSound(mysound);
}

@end
