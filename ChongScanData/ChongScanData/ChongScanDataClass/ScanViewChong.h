//
//  ScanViewChong.h
//  ChongScanData
//
//  Created by ZhengZheng Li on 2017/11/17.
//  Copyright © 2017年 CrystalChongZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanViewDelegate<NSObject>
- (void)getScanDataString:(NSString *)scanDataString;
@end


@interface ScanViewChong : UIView
typedef  NS_ENUM(NSInteger, ScanType){
    typeQR,
    typeRecent
};
@property (nonatomic, assign)id<ScanViewDelegate> delegate;
@property (nonatomic, assign)ScanType scantype;
@property (nonatomic, copy)void (^notUsePhotoBlock)(BOOL ifUse);
@end
