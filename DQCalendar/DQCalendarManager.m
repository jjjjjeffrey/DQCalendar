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
@property (nonatomic) NSInteger nextMonth;
@property (nonatomic) CGPoint currentOffset;
@property (nonatomic) NSInteger currentSection;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DQCalendarManager

- (void)setBeginDate:(NSDate *)beginDate
{
    _beginDate = beginDate;
    
    self.currentMonth = [_beginDate monthComponents];
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
        sectionDate = [[NSDate gregorianCalendar] dateByAddingComponents:monthComponents toDate:self.beginDate options:NSCalendarWrapComponents];
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

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSInteger firstWeekdayInSection = [self firstWeekdayInSection:section];
    NSInteger daysNumber = [self numberOfDaysInSection:section];
    NSInteger rowsNumber = 0;
    if (firstWeekdayInSection == 5 && daysNumber == 31) {
        rowsNumber = 6;
    } else if (firstWeekdayInSection == 6 && daysNumber >= 30) {
        rowsNumber = 6;
    } else {
        rowsNumber = 5;
    }
    
    return rowsNumber;
}

- (BOOL)isLastSection:(NSInteger)section
{
    NSInteger lastMonth = [self.endDate monthComponents];
    NSInteger sectionMonth = [self.beginDate monthComponents]+section;
    return lastMonth == sectionMonth;
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
    
    if (indexPath.row % 6 == 0 || indexPath.row % 7 == 0) {
        cell.dateLabel.textColor = [UIColor lightGrayColor];
    } else {
        cell.dateLabel.textColor = [UIColor blackColor];
    }
    
    NSDate *date = [self dateAtIndexPath:indexPath];
    NSString *dayString = [date dayComponents] == 0 ? @"" : [NSString stringWithFormat:@"%ld", [date dayComponents]];
    cell.dateLabel.text = dayString;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
    footer.backgroundColor = [UIColor lightGrayColor];
    return footer;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *indexPath = indexPaths[0];
    self.numberOfRowsInNextSection = [self numberOfRowsInSection:indexPath.section+1];
    self.numberOfRowsInCurrentSection = [self numberOfRowsInSection:indexPath.section];
    self.numberOfRowsInLastSection = [self numberOfRowsInSection:indexPath.section-1];
    
    self.currentMonth = indexPath.section+[self.beginDate monthComponents];
    self.nextMonth = self.currentMonth+1;
    self.currentOffset = scrollView.contentOffset;
    self.currentSection = indexPath.section;
    
    [self scrollReset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y > 0) {
        *targetContentOffset = CGPointMake(targetContentOffset->x, self.currentOffset.y+self.numberOfRowsInCurrentSection*60);
    } else {
        if ([self isLastSection:self.currentSection]) {
            *targetContentOffset = CGPointMake(targetContentOffset->x, self.currentOffset.y-self.numberOfRowsInCurrentSection*60);
        } else {
            *targetContentOffset = CGPointMake(targetContentOffset->x, self.currentOffset.y-self.numberOfRowsInLastSection*60);
        }
        
    }
}

- (void)scrollReset
{
    NSArray *indexPathsVisible = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *firstIndexPath = [indexPathsVisible firstObject];
    NSIndexPath *secondIndexPath = [indexPathsVisible lastObject];
    NSInteger firstIndexPathCount = 0;
    NSInteger secondIndexPathCount = 0;
    for (NSIndexPath *indexPath in indexPathsVisible) {
        if (indexPath.section == firstIndexPath.section) {
            firstIndexPathCount += 1;
        } else if (indexPath.section == secondIndexPath.section) {
            secondIndexPathCount += 1;
        }
    }
    
    
    NSIndexPath *indexPath = firstIndexPathCount >= secondIndexPathCount ? firstIndexPath : secondIndexPath;
    NSInteger rowNumber = [self numberOfRowsInSection:indexPath.section];
    self.rowOfPage = rowNumber;
}

- (void)resetAnimationDidStart
{
    
}

- (void)resetAnimationDidStop
{
    if ([self isLastSection:self.currentSection]) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.currentSection] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}


@end
