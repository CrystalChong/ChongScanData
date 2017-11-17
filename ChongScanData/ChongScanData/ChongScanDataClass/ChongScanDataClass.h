//
//  ChongScanDataClass.h
//  ChongScanData
//
//  Created by ZhengZheng Li on 2017/11/17.
//  Copyright © 2017年 CrystalChongZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChongScanDataClass : UIViewController
@property (nonatomic, copy)void(^getCodingBlock)(NSString *code);
@end
