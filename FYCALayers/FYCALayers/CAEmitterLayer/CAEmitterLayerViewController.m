//
//  CAEmitterLayerViewController.m
//  FYCALayers
//
//  Created by Charlie on 2019/3/6.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "CAEmitterLayerViewController.h"

@interface CAEmitterLayerViewController ()
{
    CAEmitterLayer *layer;
}
@end

@implementation CAEmitterLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    layer=[CAEmitterLayer layer];
    layer.frame = CGRectMake(0, 0, 200, 200);
    [self.view.layer addSublayer:layer];
    //渲染模式
    layer.renderMode = kCAEmitterLayerUnordered;
    //发射模式
    layer.emitterMode = kCAEmitterLayerPoint;
    layer.emitterPosition = CGPointMake(100, 100);
    
    CAEmitterCell *cell1=[self cellWithName:@"1"];
    CAEmitterCell *cell2=[self cellWithName:@"3"];
    CAEmitterCell *cell3=[self cellWithName:@"22"];
    //可以添加多个特效粒子
    
    layer.emitterCells = @[cell1,cell2,cell3];
}
-(CAEmitterCell *)cellWithName:(NSString *)name{
    CAEmitterCell *cell=[[CAEmitterCell alloc]init];
    cell.contents = (__bridge id)[UIImage imageNamed:name].CGImage;
    cell.birthRate = 30;//每秒创建10个cell粒子
    cell.lifetime = 1.5;//生存时间
    //    cell.color =[[UIColor redColor] CGColor];
    //每秒 透明度 -0.5
    cell.alphaSpeed = -0.5;
    cell.velocity = 50;
    //xy发射角度
    cell.emissionLongitude = 0.5;
    //速度范围
    cell.velocityRange = M_PI_4 ;
    //发射 范围
    cell.emissionRange = M_PI;
    return cell;
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point= [[touches anyObject] locationInView:self.view];
    layer.emitterPosition = point;
}


@end
