//
//  EBCalenderView.h
//  EBus
//
//  Created by Kowloon on 15/10/26.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHCalenderKit.h"
@class EBCalenderView;


@protocol EBCalenderViewDelegate <NSObject>

@optional
- (void)eb_calenderView:(EBCalenderView *)calenderView didOrder:(NSArray *)dates;
- (void)eb_calenderViewDidApply:(EBCalenderView *)calenderView;

@end

@interface EBCalenderView : UIView

@property (nonatomic, weak) IBOutlet id <EBCalenderViewDelegate>delegate;


@property (nonatomic, strong) NSDictionary *priceAndTicket;
- (void)reloadData;

@end