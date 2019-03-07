//
//  FYCAkeyFrameAnimationViewController.m
//  FYCALayers
//
//  Created by Charlie on 2019/3/7.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "FYCAkeyFrameAnimationViewController.h"

@interface FYCAkeyFrameAnimationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *dogImage;

@end

@implementation FYCAkeyFrameAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (IBAction)changeImageEasyIn:(id)sender {
    
    
//    CATransition *trans= [CATransition animation];
//    // 动画效果
//    trans.type = kCATransitionMoveIn;
//    [self.dogImage.layer addAnimation:trans forKey:nil];
    
    [UIView transitionWithView:self.dogImage
                      duration:2 options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        static int i = 0;
                        i ++;
                        if (i %2 == 0) {
                            self.dogImage.image =[UIImage imageNamed:@"1"];
                        }else{
                            self.dogImage.image =[UIImage imageNamed:@"10"];
                        }
    } completion:nil];
 
}
- (IBAction)ChangeColor:(id)sender {
    [self changeColor];
}
- (IBAction)flayCirle:(id)sender {
    [self flayWithImage];
}
- (void)changeColor{
    CAKeyframeAnimation *animation =[CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    //周期
    animation.duration =4.0f;
    //重复次数
    animation.repeatCount = 1;
    animation.values = @[(__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor blackColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor blackColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor];
    [self.view.layer addAnimation:animation forKey:@"1"];
}
-(void)flayWithImage{
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 150)];
    [path addCurveToPoint:CGPointMake(300, 250)
            controlPoint1:CGPointMake(300, 500)
            controlPoint2:CGPointMake(400, 200)];
    //飞机飞行路线
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor =[UIColor redColor].CGColor;
    shapeLayer.lineWidth = 3.0f;
    [self.view.layer addSublayer:shapeLayer];
    
    //展示飞机的图层
    CALayer *image=[CALayer layer];
    image.contents =(__bridge id)  [UIImage imageNamed:@"10.png"] .CGImage;
    image.frame = CGRectMake(0, 0, 64, 64);
    image.position = CGPointMake(0, 150);
    [self.view.layer addSublayer:image];
    
    
    //✈️动画
    CAKeyframeAnimation *animaiton=[CAKeyframeAnimation animation];
    animaiton.path = path.CGPath;
    animaiton.duration = 4.0f;
    
    animaiton.keyPath = @"position";
    animaiton.rotationMode = kCAAnimationRotateAuto;//转向自动 根据路线拐弯 而拐弯
//    [image addAnimation:animaiton forKey:nil];
    
    //飞机翻转动画

    CABasicAnimation *base=[CABasicAnimation animation];
    base.keyPath = @"transform.rotation";
    base.duration = 2.0f;
    base.byValue = @(M_PI*2);
//    [image addAnimation:base forKey:nil];
    
    //动画组  可以多个动画同时执行 现在是添加了2个动画  一个改动position ，一个的翻转。
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 4;
    group.animations = @[animaiton,base];
    [image addAnimation:group forKey:nil];
}

@end
