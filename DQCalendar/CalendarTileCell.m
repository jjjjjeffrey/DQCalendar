//
//  CalendarTileCell.m
//  DQCalendar
//
//  Created by zeng daqian on 14-7-25.
//  Copyright (c) 2014年 daqian. All rights reserved.
//

#import "CalendarTileCell.h"
#import <POP.h>

@interface CalendarTileCell ()

@property (weak, nonatomic) IBOutlet UIImageView *SelectedCircleNormalView;


@end

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

- (void)setDateSelected:(BOOL)dateSelected
{
    _dateSelected = dateSelected;
    
    [self reloadSelected];
}

- (void)reloadSelected
{
    NSString *imageName = self.isToday ? @"SelectedCircleToday" : @"SelectedCircleNormal";
    self.SelectedCircleNormalView.image = [UIImage imageNamed:imageName];
    
    if (self.dateSelected) {
        self.SelectedCircleNormalView.hidden = NO;
        self.dateLabel.textColor = [UIColor whiteColor];
        self.dateLabel.font = [UIFont boldSystemFontOfSize:18];
        [self addSelectedAnimation];
    } else {
        self.SelectedCircleNormalView.hidden = YES;
        self.dateLabel.font = [UIFont systemFontOfSize:17];
        [self reloadDateLabel];
    }
}

- (void)addSelectedAnimation
{
    POPSpringAnimation *toBig = [POPSpringAnimation animationWithPropertyNamed:kPOPViewSize];
    toBig.springBounciness = 12;
    toBig.springSpeed = 10;
    toBig.fromValue = [NSValue valueWithCGSize:CGSizeMake(25, 25)];
    toBig.toValue = [NSValue valueWithCGSize:CGSizeMake(30, 30)];
    [self.SelectedCircleNormalView pop_addAnimation:toBig forKey:nil];
}

- (void)reloadDateLabel
{
    if (self.isToday) {
        self.dateLabel.font = [UIFont boldSystemFontOfSize:17];
        self.dateLabel.textColor = [UIColor redColor];
    } else if (self.isOffDay) {
        self.dateLabel.font = [UIFont systemFontOfSize:17];
        self.dateLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.dateLabel.font = [UIFont systemFontOfSize:17];
        self.dateLabel.textColor = [UIColor blackColor];
    }
}

- (void)drawRect:(CGRect)rect
{
    
}

@end
