//
//  EBMyOrderHeaderView.h
//  EBus
//
//  Created by Kowloon on 15/11/9.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBMyOrderModel;

@interface EBMyOrderHeaderView : UITableViewHeaderFooterView

+ (EBMyOrderHeaderView *)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) EBMyOrderModel *orderModel;

@end
