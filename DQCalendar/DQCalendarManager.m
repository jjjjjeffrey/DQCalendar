//
//  DQCalendarManager.m
//  DQCalendar
//
//  Created by zeng daqian on 14-7-28.
//  Copyright (c) 2014年 daqian. All rights reserved.
//

#import "DQCalendarManager.h"
#import "NSDate+Agenda.h"
#import "CalendarTileCell.h"

@interface DQCalendarManager ()

@property (nonatomic) NSInteger numberOfRowsInNextSection;
@property (nonatomic) NSInteger numberOfRowsInCurrentSection;
@property (nonatomic) NSInteger numberOfRowsInLastSection;
@property (nonatomic) CGPoint currentOffset;
@property (nonatomic) NSInteger currentSection;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) CalendarTileCell *currentSelectedCell;

@end

@implementation DQCalendarManager

- (void)setBeginDate:(NSDate *)beginDate
{
    _beginDate = beginDate;
    
    self.currentMonthDate = _beginDate;
    self.numberOfRowsInCurrentSection = [self numberOfRowsInSection:0];
}

- (NSInteger)totalMonths
{
    return [NSDate numberOfMonthFromDate:_beginDate toDate:_endDate];
}

- (NSDate *)firstDateInSection:(NSInteger)section
{
    NSDate *sectionDate;
    if (section == 0) {
        sectionDate = self.beginDate;
    } else {
        NSDateComponents *monthComponents = [[NSDateComponents alloc] init];
        [monthComponents setMonth:section];
        sectionDate = [[NSDate gregorianCalendar] dateByAddingComponents:monthComponents toDate:self.beginDate options:0];
    }
    return sectionDate;
}

- (NSInteger)numberOfDaysInSection:(NSInteger)section
{
    NSDate *sectionDate = [self firstDateInSection:section];
    
    
    NSInteger daysNumber = [NSDate numberOfDaysInMonthForDate:sectionDate];
    return daysNumber;
}

- (NSInteger)firstWeekdayInSection:(NSInteger)section
{
    NSDate *sectionDate = [self firstDateInSection:section];
    NSInteger weekday = [sectionDate weekDay];
    return weekday;
}

- (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *firstDateInSection = [self firstDateInSection:indexPath.section];
    NSInteger firstWeekdayInSection = [self firstWeekdayInSection:indexPath.section];
    
    NSDate *dateToRetuen = nil;
    
    if (firstWeekdayInSection == 7) {
        NSDateComponents *dateComponents = [[NSDate gregorianCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:firstDateInSection];
        [dateComponents setDay:indexPath.item+1];
        dateToRetuen = [[NSDate gregorianCalendar] dateFromComponents:dateComponents];
    } else if (indexPath.item >= firstWeekdayInSection) {
        NSDateComponents *dateComponents = [[NSDate gregorianCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:firstDateInSection];
        [dateComponents setDay:indexPath.item+1-firstWeekdayInSection];
        dateToRetuen = [[NSDate gregorianCalendar] dateFromComponents:dateComponents];
    }
    return dateToRetuen;
}

- (NSIndexPath *)indexPathForDate:(NSDate *)date
{
    BOOL available = [date betweenDate:_beginDate andDate:_endDate];
    if (!available) {
        return nil;
    }
    
    NSInteger monthNumer = [NSDate numberOfMonthFromDate:_beginDate toDate:date];
    NSInteger section = monthNumer - 1;
    
    NSInteger firstWeekdayInSection = [self firstWeekdayInSection:section];
    NSInteger itemOffset = firstWeekdayInSection == 7 ? 0 : firstWeekdayInSection;
    NSInteger item = itemOffset + [date dayComponents] - 1;
    
    return [NSIndexPath indexPathForItem:item inSection:section];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSInteger firstWeekdayInSection = [self firstWeekdayInSection:section];
    NSInteger daysNumber = [self numberOfDaysInSection:section];
    NSInteger rowsNumber = 0;
    if (firstWeekdayInSection == 5 && daysNumber == 31) {
        rowsNumber = 6;
    } else if (firstWeekdayInSection == 6 && daysNumber >= 30) {
        rowsNumber = 6;
    } else if (firstWeekdayInSection == 7 && daysNumber == 28) {
        rowsNumber = 4;
    } else {
        rowsNumber = 5;
    }
    return rowsNumber;
}

- (BOOL)isLastSection:(NSInteger)section
{
    return section+1 == [self totalMonths];
}

- (void)scrollToDate:(NSDate *)toDate animated:(BOOL)animated
{
    BOOL available = [toDate betweenDate:_beginDate andDate:_endDate];
    if (!available) {
        return;
    }
    
    NSDateComponents *components = [[NSDate gregorianCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:toDate];
    NSDate *clearDate = [[NSDate gregorianCalendar] dateFromComponents:components];
    
    NSIndexPath *indexPath = [self indexPathForDate:clearDate];
    
    if (self.currentSection == indexPath.section) {
        self.currentSelectedCell.dateSelected = NO;
        CalendarTileCell *cell = (CalendarTileCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.dateSelected = YES;
        self.currentSelectedCell = cell;
    } else {
        self.currentSection = indexPath.section;
        self.currentMonthDate = clearDate;
        self.currentSelectedDate = clearDate;
        self.currentOffset = [self contentOffsetForSection:indexPath.section];
        self.rowOfPage = [self numberOfRowsInSection:self.currentSection];
        [self reloadNumberOfRowsData];
        
        NSIndexPath *scrollToIndexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];
        [self.collectionView scrollToItemAtIndexPath:scrollToIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:animated];
    }
}

- (CGPoint)contentOffsetForSection:(NSInteger)section
{
    CGFloat offSetY = 0.0;
    for (int i = 0; i < section; i++) {
        offSetY += [self numberOfRowsInSection:i] * 60;
    }
    return CGPointMake(0, offSetY);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger section = self.totalMonths;
    return section;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger daysNumber = [self numberOfDaysInSection:section];
    NSInteger weekday = [self firstWeekdayInSection:section];
    if (weekday == 7) {
        weekday = 0;//如果是周日就不加weekday
    }
    
    NSInteger itemsNumber = daysNumber + weekday;
    
    return itemsNumber;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarTileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDate *date = [self dateAtIndexPath:indexPath];
    NSString *dayString = [date dayComponents] == 0 ? @"" : [NSString stringWithFormat:@"%ld", [date dayComponents]];
    cell.dateLabel.text = dayString;
    
    cell.isToday = [date isToday];
    cell.isOffDay = [date weekDay] == 6 || [date weekDay] == 7;
    cell.dateSelected = [date isEqualToDate:self.currentSelectedDate];
    self.currentSelectedCell = cell.dateSelected ? cell : self.currentSelectedCell;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentSelectedCell.dateSelected = NO;
    self.currentSelectedCell = (CalendarTileCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.currentSelectedCell.dateSelected = YES;
    self.currentSelectedDate = [self dateAtIndexPath:indexPath];
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y > 0) {
        [self scrollToNextMonthWithTargetContentOffset:targetContentOffset];
    } else if (velocity.y < 0) {
        
        [self scrollToLastMonthWithTargetContentOffset:targetContentOffset];
        
    } else if (velocity.y == 0) {
        if (targetContentOffset->y > self.currentOffset.y) {
            [self scrollToNextMonthWithTargetContentOffset:targetContentOffset];
        } else if (targetContentOffset->y < self.currentOffset.y) {
            [self scrollToLastMonthWithTargetContentOffset:targetContentOffset];
        }
    }
    
    
}

- (void)scrollToNextMonthWithTargetContentOffset:(inout CGPoint *)targetContentOffset
{
    *targetContentOffset = CGPointMake(targetContentOffset->x, self.currentOffset.y+self.numberOfRowsInCurrentSection*60);
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.month = 1;
    if ([self.currentMonthDate compare:self.endDate] == NSOrderedAscending) {
        self.currentOffset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
        
        self.currentMonthDate = [[NSDate gregorianCalendar] dateByAddingComponents:offsetComponents toDate:self.currentMonthDate options:0];
        self.rowOfPage = [self numberOfRowsInSection:self.currentSection+1];
        self.currentSection += 1;
        
        [self reloadNumberOfRowsData];
    }
}

- (void)scrollToLastMonthWithTargetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.currentSection == 0) {
        *targetContentOffset = self.currentOffset;
        return;
    }
    
    *targetContentOffset = CGPointMake(targetContentOffset->x, self.currentOffset.y-self.numberOfRowsInLastSection*60);
    
    if ([self.currentMonthDate compare:self.beginDate] == NSOrderedDescending) {
        self.currentOffset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
        
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        offsetComponents.month = -1;
        self.currentMonthDate = [[NSDate gregorianCalendar] dateByAddingComponents:offsetComponents toDate:self.currentMonthDate options:0];
        self.rowOfPage = [self numberOfRowsInSection:self.currentSection-1];
        self.currentSection -= 1;
        
        [self reloadNumberOfRowsData];
    }
}

- (void)reloadNumberOfRowsData
{
    self.numberOfRowsInNextSection = [self numberOfRowsInSection:self.currentSection+1];
    self.numberOfRowsInCurrentSection = [self numberOfRowsInSection:self.currentSection];
    self.numberOfRowsInLastSection = [self numberOfRowsInSection:self.currentSection-1];
}


@end
