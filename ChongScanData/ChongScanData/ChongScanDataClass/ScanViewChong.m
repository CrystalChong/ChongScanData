//
//  ScanViewChong.m
//  ChongScanData
//
//  Created by ZhengZheng Li on 2017/11/17.
//  Copyright © 2017年 CrystalChongZhang. All rights reserved.
//

#import "ScanViewChong.h"
#import <AVFoundation/AVFoundation.h>
@interface ScanViewChong()
@property (nonatomic, strong)AVCaptureSession *seesion;
@end
@implementation ScanViewChong

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self instanceInputAndOutPut];
    }
    return self;
}
/*!
 *  @abstract 创建输入输出流开始扫码;
 */
- (void)instanceInputAndOutPut{
    //判断硬件是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //判断用户是否允许摄像头使用;
        NSString *string = AVMediaTypeVideo;
        if ([AVCaptureDevice authorizationStatusForMediaType:string]==AVAuthorizationStatusDenied||[AVCaptureDevice authorizationStatusForMediaType:string]==AVAuthorizationStatusRestricted) {
            self.notUsePhotoBlock(NO);
            return;
        }
        /*!
         *  @abstract
         */
//        asdfasdf

        AVCaptureDevice *device  = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];

    }
}














@end
