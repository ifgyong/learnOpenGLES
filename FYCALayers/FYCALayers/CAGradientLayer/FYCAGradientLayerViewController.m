//
//  FYCAGradientLayerViewController.m
//  FYCALayers
//
//  Created by Charlie on 2019/3/6.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "FYCAGradientLayerViewController.h"

@interface FYCAGradientLayerViewController ()

@end

@implementation FYCAGradientLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLayer];
}
- (void)addLayer{
    CAGradientLayer *layer=[CAGradientLayer layer];
    layer.frame = CGRectMake(100, 100, 200, 200);
    [self.view.layer addSublayer:layer];
    //颜色数组 cgcolor 类型
    layer.colors = @[(__bridge id)[UIColor redColor].CGColor,((__bridge id)[UIColor blackColor].CGColor),((__bridge id)[UIColor whiteColor].CGColor),((__bridge id)[UIColor greenColor].CGColor)];
    //开始起点
    layer.startPoint = CGPointMake(0, 0.5);
    //结束点
    layer.endPoint = CGPointMake(1, 0.5);
    //渐变间隔  0是开始 1是结束  每两个间隔是 距离 按照比例
    layer.locations = @[@(0),@(0.1),@(0.3),@(0.5),@(0.8)];
}
@end
