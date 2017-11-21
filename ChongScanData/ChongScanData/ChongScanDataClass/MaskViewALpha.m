//
//  MaskViewALpha.m
//  ChongScanData
//
//  Created by ZhengZheng Li on 2017/11/21.
//  Copyright © 2017年 CrystalChongZhang. All rights reserved.
//

#import "MaskViewALpha.h"

@implementation MaskViewALpha

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    [[UIColor colorWithWhite:0 alpha:0.5] setFill];
    //半透明区域
    UIRectFill(rect);

    //透明的区域
    CGRect holeRection = self.borderFrame;
    /** union: 并集
     CGRect CGRectUnion(CGRect r1, CGRect r2)
     返回并集部分rect
     */

    /** Intersection: 交集
     CGRect CGRectIntersection(CGRect r1, CGRect r2)
     返回交集部分rect
     */
    CGRect holeiInterSection = CGRectIntersection(holeRection, rect);
    [[UIColor clearColor] setFill];

    //CGContextClearRect(ctx, <#CGRect rect#>)
    //绘制
    //CGContextDrawPath(ctx, kCGPathFillStroke);
    UIRectFill(holeiInterSection);

}


@end
