//
//  ScanViewChong.m
//  ChongScanData
//
//  Created by ZhengZheng Li on 2017/11/17.
//  Copyright © 2017年 CrystalChongZhang. All rights reserved.
//

#import "ScanViewChong.h"
#import <AVFoundation/AVFoundation.h>
#import "MaskViewALpha.h"

#define KScreenWidthZC  [UIScreen mainScreen].bounds.size.width
#define KscreenHeightZC [UIScreen mainScreen].bounds.size.height

@interface ScanViewChong()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong)AVCaptureSession *seesion;
@property (nonatomic, strong)UIImage *imageBorder;
@property (nonatomic, strong)UIImage *bgViewScan;
@property (nonatomic, strong)UIImageView *line;
@end
@implementation ScanViewChong

/*!
 *  @abstract 自定义(可设置为任意形状);
 */
- (instancetype)initWithFrame:(CGRect)frame withBorderFrame:(CGRect)borderFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _creatSublaery:borderFrame];
        [self instanceInputAndOutPut:borderFrame];

    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}
/*!
 *  @abstract 创建外框
 */
- (void)_creatSublaery:(CGRect)borderFrame{
    if (CGRectIsEmpty(borderFrame)||CGRectIsNull(borderFrame)) {
        borderFrame = CGRectMake(10,KscreenHeightZC*.3,KScreenWidthZC-20, KScreenWidthZC*.7);
    }
    UIImage *scanImage = [UIImage imageNamed:@"QR"];
    CGFloat top = 34*0.5-1; // 顶端盖高度
    CGFloat bottom = top ; // 底端盖高度
    CGFloat left = 34*0.5-1; // 左端盖宽度
    CGFloat right = left; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    self.imageBorder = [scanImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}
/*
 * 创建扫描线
 */
- (void)_creatLine:(CGRect)borderFrame{
    //横线做运动;
    UIImageView *line = [[UIImageView alloc]init];
    line.frame = CGRectMake(borderFrame.origin.x, borderFrame.origin.y, borderFrame.size.width, 3);
    line.image = [UIImage imageNamed:@"scanline.png"];
    line.contentMode = UIViewContentModeScaleAspectFill;
    //    line.backgroundColor = [UIColor redColor];
    //    line.clipsToBounds = YES;
    self.line = line;
    [self addSubview:line];
}
/*!
 *  @abstract 创建输入输出流开始扫码;
 */
- (void)instanceInputAndOutPut:(CGRect)borderFrame{
    if (CGRectIsEmpty(borderFrame)||CGRectIsNull(borderFrame)) {
        borderFrame = CGRectMake(10,KscreenHeightZC*.3,KScreenWidthZC-20, KScreenWidthZC*.7);
    }
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
        [outPut setRectOfInterest:CGRectMake(borderFrame.origin.y/KscreenHeightZC, borderFrame.origin.x/KScreenWidthZC, borderFrame.size.height/KscreenHeightZC, borderFrame.size.width/KScreenWidthZC)];
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

    UIImageView * imageBorder = [[UIImageView alloc]initWithFrame:borderFrame];
    imageBorder.image = self.imageBorder;

    imageBorder.contentMode = UIViewContentModeScaleToFill;
    MaskViewALpha *view = [[MaskViewALpha alloc]initWithFrame:self.bounds];
    view.borderFrame = borderFrame;
    [self.layer addSublayer:layer];
    view.backgroundColor = [UIColor clearColor];

    [self addSubview:view];
    [self addSubview:imageBorder];

    [self _adGesture:imageBorder];
    [self _adGesture:self];

    [self.seesion startRunning];
    [self.seesion addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _creatLine:borderFrame];
        [self _creatStarAnimation:borderFrame];
    });
}
/*!
 *  @abstract 开始动画
 */
- (void)_creatStarAnimation:(CGRect)borderFrame{

    self.line.hidden = NO;
    float startY  = CGRectGetMinY(borderFrame)-200;
    NSNumber *startNumber = [[NSNumber alloc]initWithFloat:startY];
    float endY  = CGRectGetMinY(borderFrame)+CGRectGetHeight(borderFrame)-205;
    NSNumber *endNumber = [[NSNumber alloc]initWithFloat:endY];
    CABasicAnimation *animation = [ScanViewChong moveYTime:3 fromY:startNumber toY:endNumber];
    [self.line.layer addAnimation:animation forKey:@"LineAnimation"];
}
+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY{
    /*
     duration    动画的时长
     repeatCount    重复的次数。不停重复设置为 HUGE_VALF
     repeatDuration    设置动画的时间。在该时间内动画一直执行，不计次数。
     beginTime    指定动画开始的时间。从开始延迟几秒的话，设置为【CACurrentMediaTime() + 秒数】 的方式
     timingFunction    设置动画的速度变化
     autoreverses    动画结束时是否执行逆动画
     fromValue    所改变属性的起始值
     toValue    所改变属性的结束时的值
     byValue    所改变属性相同起始值的改变量
     */
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
  //  animationMove.delegate = self;
    animationMove.repeatCount  = HUGE_VALF;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
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
