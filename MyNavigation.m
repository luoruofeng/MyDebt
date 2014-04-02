//
//  MyViewController.m
//  MyDebt
//
//  Created by 罗若峰 on 13-6-12.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "MyNavigation.h"
#import "UIColor+ColorUtils.h"
@interface MyNavigation ()

@end

@implementation MyNavigation

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.tintColor = [[UIColor alloc] initWithString:@"#323232"];
    self.navigationBar.translucent = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
