//
//  EBAttentionCell.m
//  EBus
//
//  Created by Kowloon on 15/10/28.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBAttentionCell.h"
#import <Masonry/Masonry.h>
#import "EBSignModel.h"
#import "EBGroupModel.h"
#import "EBSponsorModel.h"
@interface EBAttentionCell ()

@property (nonatomic, weak) UILabel *priceLabel;

@property (nonatomic, weak) UIView *followView;
@property (nonatomic, weak) UILabel *followLabel;
@property (nonatomic, weak) UILabel *numberLabel;

@end

@implementation EBAttentionCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"EBAttentionCell";
    EBAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[EBAttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self labelImplementation];
    }
    return self;
}

- (void)labelImplementation {
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [UIFont systemFontOfSize:20];
    priceLabel.text = @"price";
    [self.contentView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UIView *follow = [[UIView alloc] init];
    UILabel *followL = [[UILabel alloc] init];
    UILabel *numberL = [[UILabel alloc] init];
    followL.textAlignment = NSTextAlignmentRight;
    numberL.textAlignment = NSTextAlignmentRight;
    followL.text =@"已报名";
    numberL.text = @"0人";
    followL.font = [UIFont systemFontOfSize:11];
    numberL.font = [UIFont boldSystemFontOfSize:13];
    [follow addSubview:followL];
    [followL addSubview:numberL];
    [self.contentView addSubview:follow];
    self.followView = follow;
    self.followLabel = followL;
    self.numberLabel = numberL;
    
//    self.priceLabel.backgroundColor = [UIColor greenColor];
//    self.followLabel.backgroundColor = [UIColor redColor];
//    self.numberLabel.backgroundColor = [UIColor purpleColor];
}

- (void)setModel:(EBBaseModel *)model {
    [super setModel:model];
    if (!model) return;
    [self setUpData:model];
    [self setUpUI:model];
}

- (void)setUpData:(EBBaseModel *)model {
    if ([model isKindOfClass:[EBSignModel class]]) {
        EBSignModel *sign = (EBSignModel *)model;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@元",sign.price];
        self.followLabel.text = @"已报名:";
        self.numberLabel.text = [NSString stringWithFormat:@"%@人",sign.perNum];
    } else if ([model isKindOfClass:[EBGroupModel class]]) {
        EBGroupModel *group = (EBGroupModel *)model;
        self.followLabel.text = @"已团:";
        self.numberLabel.text = [NSString stringWithFormat:@"%@人",group.perNum];
    } else if ([model isKindOfClass:[EBSponsorModel class]]) {
        EBSponsorModel *sponsor = (EBSponsorModel *)model;
        self.followLabel.text = @"已跟团:";
        self.numberLabel.text = [NSString stringWithFormat:@"%@人",sponsor.perNum];
    }
}

- (void)setUpUI:(EBBaseModel *)model {
    if ([model isKindOfClass:[EBSignModel class]]) {
        self.priceLabel.hidden = NO;
        self.numberLabel.textColor = EB_RGBColor(236, 173, 56);
    } else if ([model isKindOfClass:[EBGroupModel class]]) {
        self.priceLabel.hidden = NO;
        self.numberLabel.textColor = EB_RGBColor(225, 130, 131);

    } else if ([model isKindOfClass:[EBSponsorModel class]]) {
        self.priceLabel.hidden = YES;
        self.numberLabel.textColor = EB_RGBColor(147, 184, 251);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    EB_WS(ws);
    CGFloat right = 20;
    CGFloat height =  30;
    CGFloat width = 100;
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.height.mas_equalTo(@(height));//高度
        make.width.mas_equalTo(@(width));//宽度
        make.right.equalTo(ws.mas_right).with.offset(-right);//离父控件右边
    }];
    
    CGFloat followH = 20;
    [self.followView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.priceLabel.mas_bottom).with.offset(0);
        make.right.equalTo(ws.mas_right).with.offset(-right);
        make.width.mas_equalTo(@(width * 2));
        make.height.mas_equalTo(@(followH));
    }];
    
    CGFloat numberW = 30;
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.followView.mas_centerY);
        make.height.mas_equalTo(@(followH));
        make.width.mas_equalTo(@(numberW));
        make.right.equalTo(ws.followView.mas_right).with.offset(0);
    }];
    
    [self.followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.followView.mas_centerY);
        make.height.mas_equalTo(@(followH));
        make.right.equalTo(ws.numberLabel.mas_left).with.offset(0);
        make.left.equalTo(ws.followView.mas_left).with.offset(0);
    }];
    
}

@end