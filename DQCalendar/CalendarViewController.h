//
//  CalendarViewController.h
//  DQCalendar
//
//  Created by zeng daqian on 14-7-25.
//  Copyright (c) 2014年 daqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DQCalendarManager;
@interface CalendarViewController : UIViewController

@property (strong, nonatomic) IBOutlet DQCalendarManager *calendarManager;

@end
