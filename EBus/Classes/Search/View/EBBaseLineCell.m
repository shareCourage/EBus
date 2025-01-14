//
//  EBBaseLineCell.m
//  EBus
//
//  Created by Kowloon on 15/10/15.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define EB_ColorOfWord [[UIColor blackColor] colorWithAlphaComponent:0.8f]
#define EB_Top 10
#define EB_Height 30
#import "EBBaseLineCell.h"
#import "EBBaseModel.h"

@interface EBBaseLineCell ()

@property (nonatomic, weak) UIImageView *indexImageView;
@property (nonatomic, weak) UIView *firstView;
@property (nonatomic, weak) UIView *secondView;

@end

@implementation EBBaseLineCell
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInfoImplementation];
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self baseInfoImplementation];
    }
    return self;
}
- (void)firstViewImplementation {
    UIView *firstView = [[UIView alloc] init];
    UILabel *departTime = [[UILabel alloc] init];
    UILabel *totalDistance = [[UILabel alloc] init];
    UILabel *totalTime = [[UILabel alloc] init];
    
    [departTime setSystemFontOf19];
    [totalDistance setSystemFontOf15];
    [totalTime setSystemFontOf15];
    totalDistance.textColor = EB_ColorOfWord;
    totalTime.textColor = EB_ColorOfWord;

    departTime.text = @"始发";
    totalDistance.text = @"公里";
    totalTime.text = @"分钟";
    
    [firstView addSubview:departTime];
    [firstView addSubview:totalDistance];
    [firstView addSubview:totalTime];
    [self.contentView addSubview:firstView];
    
    self.departTimeL = departTime;
    self.totalDistanceL = totalDistance;
    self.totalTimeL = totalTime;
    self.firstView = firstView;
}

- (void)secondViewImplementation {
    UIView *secondView = [[UIView alloc] init];
    UILabel *departPoint = [[UILabel alloc] init];
    UILabel *endPoint = [[UILabel alloc] init];
    UIImageView *index = [[UIImageView alloc] init];
    index.contentMode = UIViewContentModeScaleAspectFit;
    index.image = [UIImage imageNamed:@"search_label"];
    
    [departPoint setSystemFontOf15];
    [endPoint setSystemFontOf15];
    departPoint.textColor = EB_ColorOfWord;
    endPoint.textColor = EB_ColorOfWord;

    departPoint.text = @"始发站";
    endPoint.text = @"终点站";
    
    
    [secondView addSubview:departPoint];
    [secondView addSubview:endPoint];
    [secondView addSubview:index];
    [self.contentView addSubview:secondView];
    
    self.departPointL = departPoint;
    self.endPointL = endPoint;
    self.indexImageView = index;
    self.secondView = secondView;
}
- (void)baseInfoImplementation {
    [self firstViewImplementation];
    [self secondViewImplementation];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self firstViewLayout];
    [self secondViewLayout];
}

- (void)firstViewLayout {
    CGFloat top = EB_Top;
    CGFloat height = EB_Height;
    CGFloat padding = 10;
    
    CGFloat firstViewX = 0;
    CGFloat firstViewY = top;
    CGFloat firstViewW = self.frame.size.width;
    CGFloat firstViewH = height;
    self.firstView.frame = CGRectMake(firstViewX, firstViewY, firstViewW, firstViewH);
    
    CGFloat departTimeX = 20;
    CGFloat departTimeY = 0;
    CGFloat departTimeH = height;
    CGFloat departTimeW = [self.departTimeL boundingRectWithSize:CGSizeMake(MAXFLOAT, height)].width;
    self.departTimeL.frame = CGRectMake(departTimeX, departTimeY, departTimeW, departTimeH);
    
    CGFloat totalDistanceX = CGRectGetMaxX(self.departTimeL.frame)  + padding;
    CGFloat totalDistanceY = 0;
    CGFloat totalDistanceW = [self.totalDistanceL boundingRectWithSize:CGSizeMake(MAXFLOAT, height)].width;
    CGFloat totalDistanceH = height;
    self.totalDistanceL.frame  = CGRectMake(totalDistanceX, totalDistanceY, totalDistanceW, totalDistanceH);
    
    CGFloat totalTimeX = CGRectGetMaxX(self.totalDistanceL.frame) + padding;
    CGFloat totalTimeY = 0;
    CGFloat totalTimeW = [self.totalTimeL boundingRectWithSize:CGSizeMake(MAXFLOAT, height)].width + 20;
    CGFloat totalTimeH = height;
    self.totalTimeL.frame  = CGRectMake(totalTimeX, totalTimeY, totalTimeW, totalTimeH);
}

- (void)secondViewLayout {
    CGFloat top = EB_Top;
    CGFloat height = EB_Height - 3;
    CGFloat padding = 10;

    CGFloat secondViewX = 0;
    CGFloat secondViewY = CGRectGetMaxY(self.firstView.frame);
    CGFloat secondViewW = self.frame.size.width;
    CGFloat secondViewH = height * 2;
    self.secondView.frame = CGRectMake(secondViewX, secondViewY, secondViewW, secondViewH);
    
    CGFloat indexImageViewX = 2 * top;
    CGFloat indexImageViewY = padding / 2;
    CGFloat indexImageViewW = 10;
    CGFloat indexImageViewH = 40;
    self.indexImageView.frame  = CGRectMake(indexImageViewX, indexImageViewY, indexImageViewW, indexImageViewH);
    
    CGFloat departPointX = CGRectGetMaxX(self.indexImageView.frame) + padding;
    CGFloat departPointY = 0;
    CGFloat departPointW = 200;
    CGFloat departPointH = height;
    self.departPointL.frame  = CGRectMake(departPointX, departPointY, departPointW, departPointH);
    
    CGFloat endPointX = CGRectGetMaxX(self.indexImageView.frame) + padding;
    CGFloat endPointY = CGRectGetMaxY(self.departPointL.frame);
    CGFloat endPointW = departPointW;
    CGFloat endPointH = height;
    self.endPointL.frame  = CGRectMake(endPointX, endPointY, endPointW, endPointH);
}

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"EBBaseLineCell";
    EBBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[EBBaseLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


- (void)setModel:(EBBaseModel *)model {
    if (!model) return;
    _model = model;
    NSArray *arrayOn = [model.onStationName componentsSeparatedByString:@"（"];
    self.departPointL.text = [arrayOn firstObject];
    NSArray *arrayOff = [model.offStationName componentsSeparatedByString:@"（"];
    self.endPointL.text = [arrayOff firstObject];
    self.departTimeL.text = [model.startTime insertSymbolString:@":" atIndex:2];
    
    NSString *needTimeStr = [NSString stringWithFormat:@"约%@分钟",model.needTime];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:needTimeStr];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:18.0]
                          range:NSMakeRange(1, 2)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:EB_ColorOfWord
                          range:NSMakeRange(1, 2)];
    self.totalTimeL.attributedText = AttributedStr;
    
    NSString *totalDStr = [NSString stringWithFormat:@"%.2f公里",[model.mileage floatValue]];
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc] initWithString:totalDStr];
    [AttributedStr1 addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:18.0]
                          range:NSMakeRange(0, 5)];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                          value:EB_ColorOfWord
                          range:NSMakeRange(0, 5)];
    self.totalDistanceL.attributedText = AttributedStr1;
}

@end



