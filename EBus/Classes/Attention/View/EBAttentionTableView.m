//
//  EBAttentionTableView.m
//  EBus
//
//  Created by Kowloon on 15/10/28.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBAttentionTableView.h"
#import <MJRefresh/MJRefresh.h>
#import "EBUsualLineCell.h"
#import "EBAttentionCell.h"
#import "EBUserInfo.h"

#import "EBBoughtModel.h"
#import "EBSignModel.h"
#import "EBGroupModel.h"
#import "EBSponsorModel.h"

@interface EBAttentionTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, strong) NSDictionary *parameters;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation EBAttentionTableView

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSDictionary *)parameters {
    if (self.tag == EBAttentionTypePurchase) {
        _parameters = @{static_Argument_userId          : [EBUserInfo sharedEBUserInfo].loginId,
                        static_Argument_userName        : [EBUserInfo sharedEBUserInfo].loginName};
    } else {
        _parameters = @{static_Argument_customerId      : [EBUserInfo sharedEBUserInfo].loginId,
                        static_Argument_customerName    : [EBUserInfo sharedEBUserInfo].loginName};
    }
    return _parameters;
}

#pragma mark - Super
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:tableView];
        EB_WS(ws);
        tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [ws tableViewRefresh];
        }];
        self.tableView = tableView;
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        backgroundImageView.contentMode = UIViewContentModeCenter;
        UIImage *image = [UIImage imageNamed:@"main_background"];
        backgroundImageView.image = image;
        tableView.backgroundView = backgroundImageView;
        self.backgroundImageView = backgroundImageView;
    }
    return self;
}

- (void)layoutSubviews {
    self.tableView.frame = self.bounds;
}

#pragma mark - Public Method
- (void)beginRefresh {
    [self.tableView.header beginRefreshing];
    self.refresh = YES;
}

#pragma mark - Private Method
- (void)tableViewRefresh {
    [self attentionRequestAndTableViewReloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tag == EBAttentionTypePurchase) {
        EBUsualLineCell *cell = [EBUsualLineCell cellWithTableView:tableView];
        cell.showBuyView = NO;
        EBBoughtModel *bought = self.dataSource[indexPath.row];
        cell.model = bought;
        return cell;
    } else if (self.tag == EBAttentionTypeSign) {
        EBAttentionCell *cell = [EBAttentionCell cellWithTableView:tableView];
        EBSignModel *sign = self.dataSource[indexPath.row];
        cell.model = sign;
        return cell;
    } else if (self.tag == EBAttentionTypeGroup) {
        EBAttentionCell *cell = [EBAttentionCell cellWithTableView:tableView];
        EBGroupModel *group = self.dataSource[indexPath.row];
        cell.model = group;
        return cell;
    } else if (self.tag == EBAttentionTypeSponsor) {
        EBAttentionCell *cell = [EBAttentionCell cellWithTableView:tableView];
        EBSponsorModel *sponsor = self.dataSource[indexPath.row];
        cell.model = sponsor;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.tag == EBAttentionTypePurchase) {
        EBBoughtModel *bought = self.dataSource[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(eb_tableView:didSelectOfTypePurchase:)]) {
            [self.delegate eb_tableView:self didSelectOfTypePurchase:bought];
        }
    } else if (self.tag == EBAttentionTypeSign) {
        EBSignModel *sign = self.dataSource[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(eb_tableView:didSelectOfTypeSign:)]) {
            [self.delegate eb_tableView:self didSelectOfTypeSign:sign];
        }
    } else if (self.tag == EBAttentionTypeGroup) {
        EBGroupModel *group = self.dataSource[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(eb_tableView:didSelectOfTypeGroup:)]) {
            [self.delegate eb_tableView:self didSelectOfTypeGroup:group];
        }
    } else if (self.tag == EBAttentionTypeSponsor) {
        [MBProgressHUD showError:@"相关路线尚未开通，详细请咨询客服" toView:self];
    }
}

#pragma mark - Network Request
- (void)attentionRequestAndTableViewReloadData {
    if ([EBTool loginEnable]) {
        switch (self.tag) {
            case EBAttentionTypePurchase:
                [self boughtRequest];
                break;
            case EBAttentionTypeSign:
                [self signRequest];
                break;
            case EBAttentionTypeGroup:
                [self groupRequest];
                break;
            case EBAttentionTypeSponsor:
                [self sponsorRequest];
                break;
            default:
                break;
        }
    } else {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        self.backgroundImageView.hidden = NO;
        [self.tableView.header endRefreshing];
    }
}

- (void)boughtRequest {
    [EBNetworkRequest GET:static_Url_AttentionOfBought parameters:self.parameters dictBlock:^(NSDictionary *dict) {
        EBLog(@"%@", dict);
        [self.tableView.header endRefreshing];
        [self.dataSource removeAllObjects];
        NSArray *array = dict[static_Argument_returnData];
        for (NSDictionary *dict in array) {
            EBBoughtModel *bought = [[EBBoughtModel alloc] initWithDict:dict];
            [self.dataSource addObject:bought];
        }
        if (self.dataSource.count == 0) {
            self.backgroundImageView.hidden = NO;
        } else {
            self.backgroundImageView.hidden = YES;
        }
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}
- (void)signRequest {
    [EBNetworkRequest GET:static_Url_AttentionOfSign parameters:self.parameters dictBlock:^(NSDictionary *dict) {
        EBLog(@"%@", dict);
        [self.tableView.header endRefreshing];
        [self.dataSource removeAllObjects];
        NSArray *array = dict[static_Argument_returnData];
        for (NSDictionary *dict in array) {
            EBSignModel *bought = [[EBSignModel alloc] initWithDict:dict];
            [self.dataSource addObject:bought];
        }
        if (self.dataSource.count == 0) {
            self.backgroundImageView.hidden = NO;
        } else {
            self.backgroundImageView.hidden = YES;
        }
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}
- (void)groupRequest {
    [EBNetworkRequest GET:static_Url_AttentionOfGroup parameters:self.parameters dictBlock:^(NSDictionary *dict) {
        EBLog(@"%@", dict);
        [self.tableView.header endRefreshing];
        [self.dataSource removeAllObjects];
        NSArray *array = dict[static_Argument_returnData];
        for (NSDictionary *dict in array) {
            EBGroupModel *bought = [[EBGroupModel alloc] initWithDict:dict];
            [self.dataSource addObject:bought];
        }
        if (self.dataSource.count == 0) {
            self.backgroundImageView.hidden = NO;
        } else {
            self.backgroundImageView.hidden = YES;
        }
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}
- (void)sponsorRequest {
    [EBNetworkRequest GET:static_Url_AttentionOfSponsor parameters:self.parameters dictBlock:^(NSDictionary *dict) {
        EBLog(@"%@", dict);
        [self.tableView.header endRefreshing];
        [self.dataSource removeAllObjects];
        NSArray *array = dict[static_Argument_returnData];
        for (NSDictionary *dict in array) {
            EBSponsorModel *bought = [[EBSponsorModel alloc] initWithDict:dict];
            [self.dataSource addObject:bought];
        }
        if (self.dataSource.count == 0) {
            self.backgroundImageView.hidden = NO;
        } else {
            self.backgroundImageView.hidden = YES;
        }
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

@end