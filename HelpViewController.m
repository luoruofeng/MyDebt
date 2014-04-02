//
//  HelpViewController.m
//  MyDebt
//
//  Created by 罗若峰 on 13-9-14.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "HelpViewController.h"
#import "LockViewController.h"

@interface HelpViewController ()
    @property (nonatomic,retain) NSTimer *timer;
    @property (nonatomic,retain) NSArray *images;
@end

@implementation HelpViewController

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}
- (void)loadView
{
    [super loadView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];

    if(SCREEN_HEIGHT == 568)
    {
        _images = [NSArray arrayWithObjects:@"help_zero" ,@"help_one",@"help_two",@"help_three",@"help_four",@"help_five4" ,nil];
    }
    else
    {
        _images = [NSArray arrayWithObjects:@"help_zero4" ,@"help_one4",@"help_two4",@"help_three4",@"help_four4" ,@"help_five4",nil];
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    CGSize scrollViewSize = CGSizeMake(self.view.frame.size.width * 6, self.view.frame.size.height);
    [_scrollView setContentSize:scrollViewSize];
    
    CGFloat viewHight = self.view.frame.size.height;
    CGFloat viewWidth = APPLICATION_FRAME.size.width;
    CGFloat imageHeight = viewHight - 20;
    CGFloat imageWidth = APPLICATION_FRAME.size.width;
    
    for (int i = 0; i < 6; i++)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + SCREEN_WIDTH*i, 0, imageWidth, imageHeight)];
        imageView.image = [UIImage imageNamed:[self.images objectAtIndex:i]];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [_scrollView addSubview:imageView];
        
        UIImageView * subImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + SCREEN_WIDTH*i, imageHeight, viewWidth, viewHight - imageHeight)];
        subImageView.backgroundColor = [UIColor colorWithString:@"#2a0f36"];
        [_scrollView addSubview:subImageView];
    }
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setFrame:CGRectMake(SCREEN_WIDTH * 5 + 35, 53, 250, 250)];
    [startButton setBackgroundColor:[UIColor clearColor]];
    [startButton addTarget:self action:@selector(startApp) forControlEvents:UIControlEventTouchDown];
    [_scrollView addSubview:startButton];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 20, self.view.frame.size.width, 20)];
    _pageControl.backgroundColor = [UIColor colorWithString:@"2a0f36"];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = 6;
    
    [self.view addSubview:_scrollView];
    [self.view addSubview:_pageControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden NS_AVAILABLE_IOS(7_0)
{
    return YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(_scrollView.contentOffset.x) / _scrollView.frame.size.width;
    _pageControl.currentPage = index;
    [self.timer invalidate];
}

-(void)startApp
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)nextPage
{
    [UIView beginAnimations:@"" context:nil];
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x+SCREEN_WIDTH, 0)];
    [UIView commitAnimations];
    
    int index = fabs(_scrollView.contentOffset.x) / _scrollView.frame.size.width;
    _pageControl.currentPage = index;
    
    if(index == self.images.count - 1)
    {
        [self.timer invalidate];
    }
}

@end
