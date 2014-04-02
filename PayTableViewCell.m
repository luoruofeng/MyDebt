//
//  CustomTableViewCell.m
//  MyDebt
//
//  Created by 罗若峰 on 13-6-16.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "PayTableViewCell.h"
#import "UIColor+ColorUtils.h"

@implementation PayTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self) {
        
        #define ROWS_ITEM_WIDTH 55
        #define ROWS_ITEM_Y_HEIGHT 15
        #define FONT_FAMILY @"华文黑体"
        
        CGRect nameRect = CGRectMake(10, ROWS_ITEM_Y_HEIGHT, 100, 55);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameRect];
        nameLabel.font = [UIFont fontWithName:FONT_FAMILY size:16];
        nameLabel.tag = 102;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:15];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        
        
        CGRect timeRect = CGRectMake(120, 28, 190, 10);
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:timeRect];
        timeLabel.font = [UIFont fontWithName:FONT_FAMILY size:10];
        timeLabel.tag = 101;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont boldSystemFontOfSize:11];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [timeLabel setTextColor:[UIColor colorWithString:@"#888888"]];
        
        CGRect moneyRect = CGRectMake(120, 44, 190, 14);
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:moneyRect];
        moneyLabel.font = [UIFont fontWithName:FONT_FAMILY size:14];
        moneyLabel.font = [UIFont boldSystemFontOfSize:15];
        moneyLabel.backgroundColor = [UIColor clearColor];
        moneyLabel.tag = 103;
        moneyLabel.textColor=[[UIColor alloc] initWithString:@"#449900"];
        [moneyLabel setTextAlignment:NSTextAlignmentRight];
        CGRect importRect = CGRectMake(0, 0, 32, 32);
        UIImage *importImage = [UIImage imageNamed:@"import_yellow.png"];
        UIImageView *importImageView = [[UIImageView alloc] initWithFrame:importRect];
        [importImageView setImage:importImage];
        importImageView.backgroundColor = [UIColor clearColor];
        importImageView.tag = 104;
        
        CGRect createTimeRect = CGRectMake(120, 16, 190, 10);
        UILabel *createTimeLabel = [[UILabel alloc] initWithFrame:createTimeRect];
        createTimeLabel.font = [UIFont fontWithName:FONT_FAMILY size:10];
        createTimeLabel.tag = 105;
        createTimeLabel.backgroundColor = [UIColor clearColor];
        createTimeLabel.font = [UIFont boldSystemFontOfSize:11];
        [createTimeLabel setTextAlignment:NSTextAlignmentRight];
        [createTimeLabel setTextColor:[UIColor colorWithString:@"#888888"]];
        
        [self.contentView addSubview:createTimeLabel];        
        [self.contentView addSubview:timeLabel];
        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:moneyLabel];
        [self.contentView addSubview:importImageView];        
        
    }
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version >= 7.0)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
