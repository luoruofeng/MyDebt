//
//  HelpViewController.h
//  MyDebt
//
//  Created by 罗若峰 on 13-9-14.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController<UIScrollViewDelegate>

    @property (strong, nonatomic) UIPageControl *pageControl;
    @property (strong, nonatomic) NSArray *pageContent;
    @property (strong,nonatomic) UIScrollView *scrollView;

@end
