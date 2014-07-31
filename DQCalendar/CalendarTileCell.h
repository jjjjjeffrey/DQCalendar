//
//  CalendarTileCell.h
//  DQCalendar
//
//  Created by zeng daqian on 14-7-25.
//  Copyright (c) 2014年 daqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarTileCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic) BOOL isToday;
@property (nonatomic) BOOL isOffDay;
@property (nonatomic) BOOL dateSelected;

@end
