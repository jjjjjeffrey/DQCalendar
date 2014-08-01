//
//  RootViewController.m
//  DQCalendar
//
//  Created by zeng daqian on 14-7-25.
//  Copyright (c) 2014年 daqian. All rights reserved.
//

#import "RootViewController.h"
#import "CalendarViewController.h"
#import <POP/POP.h>
#import "DQCalendarManager.h"
#import "NSDate+Agenda.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CalendarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarTopAlignmentConstraint;
@property (nonatomic) CGFloat lastCalendarHeightConstraint;
@property (nonatomic, weak) CalendarViewController *calendarVC;
@property (nonatomic) BOOL calendarHidden;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *todayBarButton;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[DQCalendarManager class]]) {
        if ([keyPath isEqualToString:@"rowOfPage"]) {
            [self performAnimation];
        }
        if ([keyPath isEqualToString:@"currentMonthDate"]) {
            NSInteger year = [self.calendarVC.calendarManager.currentMonthDate yearComponents];
            NSInteger month = [self.calendarVC.calendarManager.currentMonthDate monthComponents];
            self.title = [NSString stringWithFormat:@"%ld年%ld月", year, month];
        }
    }
}

- (void)performAnimation
{
    id toValue = @(0);
    if (self.calendarVC.calendarManager.rowOfPage == 4) {
        toValue = @(260);
    } else if (self.calendarVC.calendarManager.rowOfPage == 5) {
        toValue = @(320);
    } else if (self.calendarVC.calendarManager.rowOfPage == 6) {
        toValue = @(380);
    }
    
    self.lastCalendarHeightConstraint = [toValue floatValue];
    
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    animation.toValue = toValue;
    animation.duration = 0.3;
    animation.delegate = self;
    [self.CalendarHeightConstraint pop_addAnimation:animation forKey:nil];
}

- (void)hideCalendar
{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    animation.toValue = @(-self.lastCalendarHeightConstraint+64);
    animation.duration = 0.3;
    [self.calendarTopAlignmentConstraint pop_addAnimation:animation forKey:nil];
}

- (void)showCalendar
{
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    animation.toValue = @(64);
    animation.springBounciness = 12;
    animation.springSpeed = 15;
    [self.calendarTopAlignmentConstraint pop_addAnimation:animation forKey:nil];
}

- (IBAction)todayButtonClicked:(id)sender
{
    [self.calendarVC.calendarManager selectDate:[NSDate date] animated:YES];
}

- (IBAction)changeCalendarShow:(UIBarButtonItem *)sender
{
    if (self.calendarHidden) {
        sender.title = @"收起日历";
        [self showCalendar];
    } else {
        sender.title = @"展示日历";
        [self hideCalendar];
    }
    self.calendarHidden = !self.calendarHidden;
}

- (void)setCalendarHidden:(BOOL)calendarHidden
{
    _calendarHidden = calendarHidden;
    
    self.todayBarButton.enabled = !calendarHidden;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.calendarHidden = NO;
    
    self.lastCalendarHeightConstraint = self.CalendarHeightConstraint.constant;

    self.calendarVC = (CalendarViewController *)self.childViewControllers[0];
    
    NSDateComponents *components = [NSDateComponents new];
    components.month = 2;
    components.day = 1;
    components.year = 2014;
    NSDate *fromDate = [[NSDate gregorianCalendar] dateFromComponents:components];
    components.year = 2020;
    components.month = 12;
    components.day = 1;
    NSDate *toDate = [[NSDate gregorianCalendar] dateFromComponents:components];
    
    self.calendarVC.calendarManager.beginDate = fromDate;
    self.calendarVC.calendarManager.endDate = toDate;
    [self.calendarVC.calendarManager addObserver:self forKeyPath:@"rowOfPage" options:NSKeyValueObservingOptionNew context:nil];
    [self.calendarVC.calendarManager addObserver:self forKeyPath:@"currentMonthDate" options:NSKeyValueObservingOptionNew context:nil];
    
    self.calendarVC.calendarManager.delegate = self;
    
    NSInteger year = [self.calendarVC.calendarManager.currentMonthDate yearComponents];
    NSInteger month = [self.calendarVC.calendarManager.currentMonthDate monthComponents];
    self.title = [NSString stringWithFormat:@"%ld年%ld月", year, month];
}

#pragma mark - DQCalendarDelegate
- (void)calendar:(DQCalendarManager *)calendar didSelectDate:(NSDate *)date
{
    NSLog(@"Did select date: %@", [date DEC_YMD]);
}

- (void)calendar:(DQCalendarManager *)calendar didScrollToDate:(NSDate *)date
{
    NSLog(@"Did scroll to date: %@", [date DEC_YMD]);
}

#pragma mark - POPAnimationDelegate
- (void)pop_animationDidStart:(POPAnimation *)anim
{

}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
