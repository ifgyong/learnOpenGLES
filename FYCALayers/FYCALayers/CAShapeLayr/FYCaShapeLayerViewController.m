//
//  FYCaShapeLayerViewController.m
//  FYCALayers
//
//  Created by Charlie on 2019/3/6.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "FYCaShapeLayerViewController.h"

@interface FYCaShapeLayerViewController ()

@end

@implementation FYCaShapeLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawLine];
    [self addViewCorner:UIRectCornerTopLeft|UIRectCornerTopRight];
}
-(void)drawLine{
    UIBezierPath *path =[[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(175, 100)];
    [path addArcWithCenter:CGPointMake(150, 100)
                    radius:25
                startAngle:0
                  endAngle:M_PI
                 clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.strokeColor = [[UIColor redColor] CGColor];
    shapeLayer.fillColor = [[UIColor lightGrayColor] CGColor];
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapSquare;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}
-(void)addViewCorner:(UIRectCorner)corner{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(100, 350, 100, 100)];
    view.backgroundColor =[UIColor lightGrayColor];
    [self.view addSubview:view];
    UIBezierPath *path=[UIBezierPath bezierPathWithRoundedRect:view.bounds
                                             byRoundingCorners:corner
                                                   cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *cashape=[CAShapeLayer layer];
    cashape.frame = view.bounds;
    cashape.path = path.CGPath;
    cashape.backgroundColor =[UIColor greenColor].CGColor;
    cashape.lineWidth = 2;
    //用蒙版的功能 切成圆角
//    view.layer .mask =cashape;
//蒙版直接也把阴影给过滤掉了，蒙版是过滤结果的，就是view的背景，都过滤
    CAShapeLayer *layer=[CAShapeLayer layer];
    //阴影要设置背景颜色
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    //阴影颜色
    layer.shadowColor = [UIColor redColor].CGColor;
    //阴影角度
    layer.shadowOffset = CGSizeMake(0, 10);
    //阴影半径
    layer.shadowRadius = 15;
    //frame
    layer.frame = view.bounds;
    //透明度
    layer.shadowOpacity = 0.8f;
    [view.layer addSublayer:layer];
    
}

@end
