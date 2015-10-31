//
//  EBSuggestController.m
//  EBus
//
//  Created by Kowloon on 15/10/27.
//  Copyright © 2015年 Goome. All rights reserved.
//

#warning message 还需要继续修改
#import "EBSuggestController.h"
#import "EBUserInfo.h"

@interface EBSuggestController ()

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *suggestBtns;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet UITextView *suggestTextView;

- (IBAction)commitClick:(id)sender;

@property (nonatomic, strong) NSArray *btnTitles;
@property (nonatomic, strong) NSMutableArray *types;
@end

@implementation EBSuggestController
- (NSMutableArray *)types {
    if (!_types) {
        _types = [NSMutableArray array];
    }
    return _types;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnTitles = @[@"线路优化",@"功能/操作",@"司机服务",@"车辆配置",@"订单/费用",@"其它"];
    self.commitBtn.layer.cornerRadius = self.commitBtn.frame.size.height / 2;
    [self.commitBtn setBackgroundColor:EB_DefaultColor];
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    int i = 1000;
    for (UIButton *btn in self.suggestBtns) {
        btn.tag = i;
        btn.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f].CGColor;
        btn.layer.borderWidth = 0.5f;
        [btn setTitle:self.btnTitles[i - 1000] forState:UIControlStateNormal];
        i ++;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.suggestTextView.layer.cornerRadius = 5;
    self.suggestTextView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6f].CGColor;
    self.suggestTextView.layer.borderWidth = 1.f;
    self.suggestTextView.keyboardType = UIKeyboardTypeDefault;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
}
- (void)btnClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        [sender setBackgroundColor:EB_DefaultColor];
    } else {
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
}
- (void)tapClick {
    [self.view endEditing:YES];
}
- (IBAction)commitClick:(id)sender {
    [self.types removeAllObjects];
    NSString *textString = nil;
    if (self.suggestTextView.text.length == 0) {
        textString = @" haha";
    } else {
        textString = self.suggestTextView.text;
    }
    NSString *unicodeStr = [NSString stringWithCString:[textString UTF8String] encoding:NSUnicodeStringEncoding];
    for (UIButton *btn in self.suggestBtns) {
        if (btn.isSelected) {
            switch (btn.tag) {
                case 1000:
                    [self.types addObject:@"1"];
                    break;
                case 1001:
                    [self.types addObject:@"2"];
                    break;
                case 1002:
                    [self.types addObject:@"3"];
                    break;
                case 1003:
                    [self.types addObject:@"4"];
                    break;
                case 1004:
                    [self.types addObject:@"5"];
                    break;
                case 1005:
                    [self.types addObject:@"9"];
                    break;
                default:
                    break;
            }
        }
    }
    if (self.types.count == 0) {
        [MBProgressHUD showError:@"请选择一个投诉" toView:self.view];
        return;
    }
    NSString *string = [self.types firstObject];
    for (NSString *obj in self.types) {
        if (![string isEqualToString:obj]) {
            string = [string stringByAppendingString:@","];
        }
    }
    NSDictionary *parameters = @{static_Argument_customerId : [EBUserInfo sharedEBUserInfo].loginId,
                                 static_Argument_customerName : [EBUserInfo sharedEBUserInfo].loginName,
                                 static_Argument_content : unicodeStr,
                                 static_Argument_type : string};
    [EBNetworkRequest POST:static_Url_Suggest parameters:parameters dictBlock:^(NSDictionary *dict) {
        NSString *string = [NSString stringWithFormat:@"%@",dict[@"returnCode"]];
        if ([string integerValue] == 500) {
            [MBProgressHUD showSuccess:@"谢谢您的建议" toView:self.view];
        } else {
            [MBProgressHUD showError:@"投诉失败" toView:self.view];
        }
    } errorBlock:^(NSError *error) {
        [MBProgressHUD showError:@"投诉失败" toView:self.view];
    }];
}
@end


