//
//  LockViewController.m
//  MyDebt
//
//  Created by 罗若峰 on 13-8-30.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "LockViewController.h"
#import "UIView-TagExtensions.h"
#import "SettingViewController.h"

@interface LockViewController ()

@property NSArray *subviews;
@property NSMutableArray *passwordArray;



@end

@implementation LockViewController

@synthesize
    subviews=subviews,
    passwordArray=passwordArray,
contentViewController=contentViewController;



- (id)init
{
    self = [super initWithNibName:@"LockViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    UITextField *password1 = (UITextField *)[self.view viewWithTag:101];
    UITextField *password2 = (UITextField *)[self.view viewWithTag:102];
    UITextField *password3 = (UITextField *)[self.view viewWithTag:103];
    UITextField *password4 = (UITextField *)[self.view viewWithTag:104];

    passwordArray = [NSMutableArray arrayWithObjects:password1,password2,password3,password4, nil];
    
    [password1 setEnabled:NO];
    [password2 setEnabled:NO];
    [password3 setEnabled:NO];
    [password4 setEnabled:NO];
    
    UILabel *okLabel = (UILabel *)[self.view viewWithTag:1011];
    UIButton *oKButton = (UIButton *)[self.view viewWithTag:11];
    if([self isLockPage])
    {
        [okLabel removeFromSuperview];
        [oKButton removeFromSuperview];
    }
    
}

-(void)editButton
{
    if(passwordArray)
    {
        UITextField *lastPassword =  [passwordArray lastObject];
        UILabel *okButton = (UILabel *)[self.view viewWithTag:1011];
        NSString *pw =[[NSUserDefaults standardUserDefaults] stringForKey:CONFIGE_PASSWORD];
        BOOL isUsePw =[[NSUserDefaults standardUserDefaults] boolForKey:CONFIGE_USE_PASSWORD];
        
        if(lastPassword &&lastPassword.text && ![lastPassword.text isEqualToString:@""] && [self isLockPage] && isUsePw && pw)
        {
            NSString *inputPw = [NSString stringWithFormat:@"%@%@%@%@",((UITextField *)[passwordArray objectAtIndex:0]).text,((UITextField *)[passwordArray objectAtIndex:1]).text,((UITextField *)[passwordArray objectAtIndex:2]).text,((UITextField *)[passwordArray objectAtIndex:3]).text,nil];
            
            if(pw && [pw isEqualToString:inputPw])
            {
                [self dismissModalViewControllerAnimated:YES];
            }
            else
            {
                UIImageView *lockImage = (UIImageView *)[self.view viewWithTag:12];
                
                CGPoint oldPoint = lockImage.layer.position;
                CGFloat oldPointX = oldPoint.x;
                CGPoint leftPoint = CGPointMake(oldPointX-5, oldPoint.y);
                CGPoint rightPoint = CGPointMake(oldPointX+5, oldPoint.y);
                CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                                 animationWithKeyPath:@"position"];
                animation.values  =  [NSArray arrayWithObjects:
                                     [NSValue valueWithCGPoint:leftPoint],
                                     [NSValue valueWithCGPoint:rightPoint],
                                     [NSValue valueWithCGPoint:leftPoint],
                                      [NSValue valueWithCGPoint:rightPoint],
                                      
                                      nil];
                
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                
                animation.duration = 0.2;          // Use a longer duration to allow for bounce time
                [animation setAutoreverses:YES];
                
                [lockImage.layer addAnimation:animation forKey:@"animation"];

                
                for(UITextField *text in passwordArray)
                {
                    [text setText:nil];
                }
            }
        }
        
        if(lastPassword && lastPassword.text && ![lastPassword.text isEqualToString:@""])
        {
            okButton.text = @"确定";
        }
        else
        {
            okButton.text = @"取消";
        }
    }
}


-(IBAction)keyBoradButtonDown:(id)sender
{
    if(sender && [sender isKindOfClass:[UIButton class]])
    {
        UIButton *currentButton = (UIButton *)sender;
        if(currentButton.tag >= 0 && currentButton.tag <= 9)
        {
            for(UITextField *password in passwordArray)
            {
                if(!password.text || [password.text isEqualToString:@""])
                {
                    [password setText:[NSString stringWithFormat:@"%d",currentButton.tag,nil]];
                    break;
                }
            }
        }
        else if (currentButton.tag == 10)
        {
            NSMutableString *currentPassword = [NSMutableString stringWithString:@""];
            for(UITextField *password in passwordArray)
            {
                if(password.text && ![password.text isEqualToString:@""])
                {
                    [currentPassword appendString:password.text];
                }
            }
            if(currentPassword && ![currentPassword isEqualToString:@""])
            {
                UITextField *lastWord = [passwordArray objectAtIndex:[currentPassword length] - 1];
                [lastWord setText:@""];
            }
        }
        else if (currentButton.tag == 11)
        {
            NSMutableString *currentPassword = [NSMutableString stringWithString:@""];
            for(UITextField *password in passwordArray)
            {
                if(password.text && ![password.text isEqualToString:@""])
                {
                    [currentPassword appendString:password.text];
                }
            }
            if(currentPassword && [currentPassword length] == 4)
            {
                [USER_DEFAULTS setValue:currentPassword forKey:CONFIGE_PASSWORD];
                BOOL isSuccess = [USER_DEFAULTS synchronize];
                
                UIAlertView *alert;
                if(isSuccess)
                {
                    alert = [[UIAlertView alloc] initWithTitle:@"密码保存成功" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                }
                else
                {
                    alert = [[UIAlertView alloc] initWithTitle:@"密码保存失败" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                }
                [alert show];
                [self dismissModalViewControllerAnimated:YES];
            }
            else
            {
                [self dismissModalViewControllerAnimated:YES];

                [USER_DEFAULTS setBool:NO forKey:CONFIGE_USE_PASSWORD];
                [USER_DEFAULTS synchronize];
            }
        }
        [self editButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
