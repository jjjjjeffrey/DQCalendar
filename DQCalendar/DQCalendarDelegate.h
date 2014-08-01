//
//  DQCalendarDelegate.h
//  DQCalendar
//
//  Created by zeng daqian on 14-8-1.
//  Copyright (c) 2014年 daqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DQCalendarManager;
@protocol DQCalendarDelegate <NSObject>

- (void)calendar:(DQCalendarManager *)calendar didSelectDate:(NSDate *)date;

- (void)calendar:(DQCalendarManager *)calendar didScrollToDate:(NSDate *)date;

@end
