//
//  EBUserInfo.h
//  EBus
//
//  Created by Kowloon on 15/10/23.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@class PHCalenderDay;

@interface EBUserInfo : NSObject

singleton_interface(EBUserInfo)

@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *loginId;

/* 用户日历上的当天 */
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) PHCalenderDay *currentCalendarDay;
@property (nonatomic, strong) NSMutableArray *calendarDays; // 当前月份展示的日历天
@property (nonatomic, strong) NSMutableArray *daysInPreviousMonth;
@property (nonatomic, strong) NSMutableArray *daysInCurrentMonth;
@property (nonatomic, strong) NSMutableArray *daysInFollowingMonth;

@end
