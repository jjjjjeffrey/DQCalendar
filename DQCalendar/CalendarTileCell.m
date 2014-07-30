//
//  CalendarTileCell.m
//  DQCalendar
//
//  Created by zeng daqian on 14-7-25.
//  Copyright (c) 2014年 daqian. All rights reserved.
//

#import "CalendarTileCell.h"

@implementation CalendarTileCell

- (void)awakeFromNib
{
    [self addSeparatorLayer];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)addSeparatorLayer
{
    CALayer *separatorLayer = [[CALayer alloc] init];
    separatorLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    separatorLayer.frame = CGRectMake(0, 0, 46, 0.5);
    [self.layer addSublayer:separatorLayer];
}

- (void)setIsOffDay:(BOOL)isOffDay
{
    _isOffDay = isOffDay;
    
    [self reloadDateLabel];
}

- (void)setIsToday:(BOOL)isToday
{
    _isToday = isToday;
    
    [self reloadDateLabel];
}

- (void)reloadDateLabel
{
    if (self.isToday) {
        self.dateLabel.textColor = [UIColor redColor];
    } else if (self.isOffDay) {
        self.dateLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.dateLabel.textColor = [UIColor blackColor];
    }
}


- (void)drawRect:(CGRect)rect
{
    
}

@end
