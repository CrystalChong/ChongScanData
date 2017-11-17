//
//  ScanViewChong.m
//  ChongScanData
//
//  Created by ZhengZheng Li on 2017/11/17.
//  Copyright © 2017年 CrystalChongZhang. All rights reserved.
//

#import "ScanViewChong.h"
#import <AVFoundation/AVFoundation.h>
@interface ScanViewChong()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong)AVCaptureSession *seesion;
@property (nonatomic, strong)UIImage *imageBorder;
@end
@implementation ScanViewChong

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _creatSublaery];
        [self instanceInputAndOutPut];
    }
    return self;
}
/*!
 *  @abstract 创建外框
 */
- (void)_creatSublaery{
    UIImage *scanImage = [UIImage imageNamed:@"QR"];
    CGFloat top = 34*0.5-1; // 顶端盖高度
    CGFloat bottom = top ; // 底端盖高度
    CGFloat left = 34*0.5-1; // 左端盖宽度
    CGFloat right = left; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    self.imageBorder = [scanImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];

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
         *  @abstract 输入输出流
         */
        AVCaptureDevice *device  = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        AVCaptureMetadataOutput *outPut = [[AVCaptureMetadataOutput alloc]init];
        //主线程中处理截取到的数据;
        [outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        self.seesion = [[AVCaptureSession alloc]init];
        [self.seesion addInput:input];
        [self.seesion addOutput:outPut];
        NSMutableArray *array = [NSMutableArray array];
        if (self.scantype==typeQR) {
            if ([outPut.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
                [array addObject:AVMetadataObjectTypeQRCode];
            }
        }else if(self.scantype==typeRecent){
            if ([outPut.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
                [array addObject:AVMetadataObjectTypeEAN13Code];
            }
            if ([outPut.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
                [array addObject:AVMetadataObjectTypeEAN8Code];
            }
            if ([outPut.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
                [array addObject:AVMetadataObjectTypeCode128Code];
            }
        }else if(self.scantype==typeALL){
            if ([outPut.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
                [array addObject:AVMetadataObjectTypeQRCode];
            }
            if ([outPut.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
                [array addObject:AVMetadataObjectTypeEAN13Code];
            }
            if ([outPut.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
                [array addObject:AVMetadataObjectTypeEAN8Code];
            }
            if ([outPut.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
                [array addObject:AVMetadataObjectTypeCode128Code];
            }
        }
        outPut.metadataObjectTypes = array;
    }
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.seesion];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.layer.frame;
    layer.backgroundColor = [UIColor clearColor].CGColor;

    UIImageView * imageBorder = [[UIImageView alloc]initWithFrame:self.bounds];
    imageBorder.image = self.imageBorder;
    imageBorder.contentMode = UIViewContentModeScaleToFill;
    [layer addSublayer:imageBorder.layer];
//    [self _adGesture:imageBorder];
    [self _adGesture:self];

    [self.layer addSublayer:layer];
    [self.seesion startRunning];
    [self.seesion addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)_adGesture:(UIView *)view{
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_gestureWith)];
    tap.numberOfTapsRequired = 2;
    [view addGestureRecognizer:tap];

    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(_gestureWith)];
    swip.direction = UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft;
    [view addGestureRecognizer:swip];

}
- (void)_gestureWith{
    if (self.disMissBlock) {
        self.disMissBlock(YES);
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    //监听扫码状态
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;//是否在动画;
        if (isRunning) {

        }
    }
}
//获取扫码结果;
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [self.seesion stopRunning];
        AVMetadataMachineReadableCodeObject *me =metadataObjects[0];
        NSLog(@"%@",me.stringValue);
        if (self.delegate&&[self.delegate respondsToSelector:@selector(getScanDataString:)]) {
            [_delegate getScanDataString:me.stringValue];
        }
    }

}











@end
