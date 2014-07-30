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
@property (nonatomic) NSInteger lastSectionOfPage;
@property (nonatomic, weak) CalendarViewController *calendarVC;
@property (nonatomic) NSInteger currentMonth;

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
            if (self.calendarVC.calendarManager.rowOfPage != self.lastSectionOfPage) {
                self.lastSectionOfPage = self.calendarVC.calendarManager.rowOfPage;
                [self performAnimation];
            }
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
    
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    animation.toValue = self.lastSectionOfPage == 5 ? @(320) : @(380);
    animation.duration = 0.3;
    animation.delegate = self;
    [self.CalendarHeightConstraint pop_addAnimation:animation forKey:nil];
    
    
    
//    [UIView animateWithDuration:1 animations:^{
//        self.CalendarHeightConstraint.constant = self.lastSectionOfPage == 5 ? 320 : 380;
//    } completion:^(BOOL finished){}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.lastSectionOfPage = 5;

    self.calendarVC = (CalendarViewController *)self.childViewControllers[0];
    
    NSDateComponents *components = [NSDateComponents new];
    components.month = 2;
    components.day = 1;
    components.year = 2014;
    NSDate *fromDate = [[NSDate gregorianCalendar] dateFromComponents:components];
    components.year = 2015;
    components.month = 12;
    components.day = 1;
    NSDate *toDate = [[NSDate gregorianCalendar] dateFromComponents:components];
    
    self.currentMonth = [fromDate monthComponents];
    self.calendarVC.calendarManager.beginDate = fromDate;
    self.calendarVC.calendarManager.endDate = toDate;
    [self.calendarVC.calendarManager addObserver:self forKeyPath:@"rowOfPage" options:NSKeyValueObservingOptionNew context:nil];
    [self.calendarVC.calendarManager addObserver:self forKeyPath:@"currentMonthDate" options:NSKeyValueObservingOptionNew context:nil];
    
    NSInteger year = [self.calendarVC.calendarManager.currentMonthDate yearComponents];
    NSInteger month = [self.calendarVC.calendarManager.currentMonthDate monthComponents];
    self.title = [NSString stringWithFormat:@"%ld年%ld月", year, month];
}

#pragma mark - POPAnimationDelegate
- (void)pop_animationDidStart:(POPAnimation *)anim
{
    [self.calendarVC.calendarManager resetAnimationDidStart];
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished
{
    
    [self.calendarVC.calendarManager resetAnimationDidStop];
    
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
