//
//  CalCollectionViewFlowLayout.m
//  DQCalendar
//
//  Created by zeng daqian on 14-7-29.
//  Copyright (c) 2014年 daqian. All rights reserved.
//

#import "CalCollectionViewFlowLayout.h"

@implementation CalCollectionViewFlowLayout

- (CGSize)collectionViewContentSize
{
    NSLog(@"contentSize\n");
    return CGSizeMake(320, 300);
}

@end
