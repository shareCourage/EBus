//
//  EBRefundController.m
//  EBus
//
//  Created by Kowloon on 15/11/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBRefundController.h"
#import "EBOrderSpecificModel.h"
#import "EBRefundCell.h"
#import "EBUserInfo.h"
#import "EBSecondList.h"

@interface EBRefundController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *refundBtn;
- (IBAction)refundClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *upL;
@property (weak, nonatomic) IBOutlet UILabel *downL;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *refundDates;

@end

@implementation EBRefundController
- (NSMutableArray *)refundDates {
    if (!_refundDates) {
        _refundDates = [NSMutableArray array];
    }
    return _refundDates;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setSpecificModel:(EBOrderSpecificModel *)specificModel {
    _specificModel = specificModel;
    for (EBSecondList *secL in specificModel.secondList) {
        NSInteger payStatus = [secL.status integerValue];
        if (payStatus == 2 && [EBTool eb_isWaitingWithDate:secL.runDate startTime:secL.startTime]) {
            [self.dataSource addObject:secL];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"退票";
    self.upL.text = @"退票天数:";
    self.downL.text = @"退票金额:";
    self.refundBtn.backgroundColor = EB_DefaultColor;
    self.refundBtn.layer.cornerRadius = 20;
    CGFloat tvH = EB_HeightOfScreen - EB_HeightOfNavigationBar - 60;
    CGRect tvF = CGRectMake(0, EB_HeightOfNavigationBar, EB_WidthOfScreen, tvH);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tvF style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}



- (IBAction)refundClick:(id)sender {
    if (self.refundDates.count == 0) {
        [MBProgressHUD showError:@"需退票的日期不可为空" toView:self.view];
    } else {
        [self refundRequest];
    }
}
- (void)refundRequest {
    NSDictionary *parameters = @{static_Argument_userName : [EBUserInfo sharedEBUserInfo].loginName,
                                 static_Argument_userId : [EBUserInfo sharedEBUserInfo].loginId};
    NSMutableDictionary *mParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (self.specificModel.vehTime.length != 0 ) {
        [mParameters setObject:self.specificModel.vehTime forKey:static_Argument_vehTime];
    }
    if (self.specificModel.startTime != 0) {
        [mParameters setObject:self.specificModel.startTime forKey:static_Argument_startTime];
    }
    if (self.specificModel.lineId) {
        [mParameters setObject:self.specificModel.lineId forKey:static_Argument_lineId];
    }
    NSMutableArray *array = [NSMutableArray array];
    for (EBSecondList *seclM in self.refundDates) {
        [array addObject:seclM.runDate];
    }
    NSString *salesString = [EBTool stringConnected:array connectString:@","];
    if (salesString.length != 0) {
        [mParameters setObject:salesString forKey:static_Argument_runDate];
    }
    [EBNetworkRequest GET:static_Url_Refund parameters:mParameters dictBlock:^(NSDictionary *dict) {
        EBLog(@"%@",dict);
        NSString *code = dict[static_Argument_returnCode];
        NSString *info = dict[static_Argument_returnInfo];
        if ([code integerValue] == 500) {
            [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIViewController *vc = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:vc animated:YES];
            });
        } else {
            [MBProgressHUD showError:info toView:self.view];
        }
    } errorBlock:^(NSError *error) {
        [MBProgressHUD showError:@"退款失败" toView:self.view];
    }];
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EBRefundCell *cell = [EBRefundCell cellWithTableView:tableView];
    EBSecondList *seclM = self.dataSource[indexPath.row];
    cell.seclModel = seclM;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![cell isKindOfClass:[EBRefundCell class]]) return;
    EBRefundCell *refundCell = (EBRefundCell *)cell;
    refundCell.refundCellSelected = !refundCell.isRefundCellSelected;
    EBSecondList *seclM = self.dataSource[indexPath.row];
    if (refundCell.isRefundCellSelected) {
        [self.refundDates addObject:seclM];
    } else {
        NSUInteger i = 0;
        for (EBSecondList *objSeclM in self.refundDates) {
            if (objSeclM == seclM) {
                [self.refundDates removeObjectAtIndex:i];
                break;
            }
            i ++;
        }
    }
    if (self.refundDates.count == 0) {
        self.upL.text = @"退票天数：0天";
        self.downL.text = @"退票金额：0.0元";
    } else {
        CGFloat totalPrice = 0.f;
        for (EBSecondList *seclM in self.refundDates) {
            EBLog(@"%@",seclM.runDate);
            totalPrice = [seclM.tradePrice doubleValue] + totalPrice;
        }
        self.upL.text = [NSString stringWithFormat:@"退票天数：%ld天",(unsigned long)self.refundDates.count];
        self.downL.text = [NSString stringWithFormat:@"退票金额：%.1f元",totalPrice];
    }
}

@end






