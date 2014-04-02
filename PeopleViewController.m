//
//  PeopleViewController.m
//  MyDebt
//
//  Created by 罗若峰 on 13-6-16.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "PeopleViewController.h"

@interface PeopleViewController ()

@end

@implementation PeopleViewController


- (id)init
{
    self = [super init];
    if (self) {
        self.title=@"联系人";
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
