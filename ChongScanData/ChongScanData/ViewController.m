//
//  ViewController.m
//  ChongScanData
//
//  Created by ZhengZheng Li on 2017/11/17.
//  Copyright © 2017年 CrystalChongZhang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"开始界面";
    UIButton *bvtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];

    [bvtn setTitle:@"点击" forState:UIControlStateNormal];
    [bvtn addTarget:self action:@selector(_cratBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bvtn setBackgroundColor:[UIColor purpleColor]];
    [self.view addSubview:bvtn];
}
- (void)_cratBtnAction{
    
}

@end
