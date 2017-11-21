//
//  ChongScanDataClass.m
//  ChongScanData
//
//  Created by ZhengZheng Li on 2017/11/17.
//  Copyright © 2017年 CrystalChongZhang. All rights reserved.
//

#import "ChongScanDataClass.h"
#import "ScanViewChong.h"

#define KScreenWidthZC  [UIScreen mainScreen].bounds.size.width
#define KscreenHeightZC [UIScreen mainScreen].bounds.size.height
@interface ChongScanDataClass ()<ScanViewDelegate>

@end

@implementation ChongScanDataClass

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"扫码界面";
    //asdfasdfasdfasdf
    self.view.backgroundColor = [UIColor redColor];

    [self _creatSbView];
    // Do any additional setup after loading the view.
}
//在试图将要已将出现的方法中
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        //调用隐藏方法
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}
//实现隐藏方法
- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)_creatSbView{
    ScanViewChong *chong = [[ScanViewChong alloc]initWithFrame:self.view.bounds withBorderFrame:CGRectMake(10,KscreenHeightZC*.3,KScreenWidthZC-20, KScreenWidthZC*.7)];
    chong.disMissBlock = ^(BOOL isDissMiss) {
        if (isDissMiss) {
            if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    };
    chong.delegate = self;
    chong.scantype = typeALL;//二维码和条形码;
    [self.view addSubview:chong];
}
-(void)getScanDataString:(NSString *)scanDataString{
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.getCodingBlock) {
        self.getCodingBlock(scanDataString);
    }
}


@end
