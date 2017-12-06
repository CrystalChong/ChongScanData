//
//  ViewController.m
//  ChongScanData
//
//  Created by ZhengZheng Li on 2017/11/17.
//  Copyright © 2017年 CrystalChongZhang. All rights reserved.
//

#import "ViewController.h"
#import "ChongScanDataClass.h"


@interface ViewController ()

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"开始界面";
    UIButton *bvtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 100, 40)];

    [bvtn setTitle:@"点击" forState:UIControlStateNormal];
    [bvtn addTarget:self action:@selector(_cratBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bvtn setBackgroundColor:[UIColor purpleColor]];
    [self.view addSubview:bvtn];
}
- (void)_cratBtnAction:(UIButton *)btn{


    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 300, 300, 100)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.textColor = [UIColor purpleColor];
    [self.view addSubview:label];

    ChongScanDataClass *chong = [[ChongScanDataClass alloc]init];
    chong.getCodingBlock = ^(NSString *code) {
        label.text = code;
    };
    [self presentViewController:chong animated:YES completion:nil];
}

@end
