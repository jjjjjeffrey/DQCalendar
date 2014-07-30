//
//  DQCalendarManager.h
//  DQCalendar
//
//  Created by zeng daqian on 14-7-28.
//  Copyright (c) 2014年 daqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQCalendarManager : NSObject

@property (nonatomic) NSInteger rowOfPage;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic) NSInteger totalMonths;
@property (nonatomic, strong) NSDate *currentMonthDate;
@property (nonatomic) NSInteger currentSectionOfMonth;
@property (nonatomic) NSInteger currentMonth;

- (void)resetAnimationDidStart;
- (void)resetAnimationDidStop;

@end
