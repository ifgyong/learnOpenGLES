//
//  CATransformEasyInViewController.m
//  FYCALayers
//
//  Created by Charlie on 2019/3/7.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "CATransformEasyInViewController.h"

@interface CATransformEasyInViewController (){
    CALayer *_layer;
}

@property (weak, nonatomic) IBOutlet UIImageView *image;
@end

@implementation CATransformEasyInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}
- (IBAction)changeColor:(id)sender {
    [self addLayer];
    
    
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animation];
    animation.duration = 2.0f;
    animation.keyPath = @"backgroundColor";
    animation.values = @[(__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor blackColor].CGColor,
                         (__bridge id)[UIColor whiteColor].CGColor];
    CAMediaTimingFunction *fun=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    CAMediaTimingFunction *fun1=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CAMediaTimingFunction *fun2=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//过渡性动画 根据类型不同 速率不同
    animation.timingFunctions = @[fun,fun1,fun2];
    [_layer addAnimation:animation forKey:nil];
}
- (void)addLayer{
    if (_layer == nil) {
        _layer=[CALayer layer];
        _layer.backgroundColor =[UIColor redColor].CGColor;
        _layer.frame = CGRectMake(100, 100, 200, 200);
        [self.view.layer addSublayer:_layer];
    }
}

// 效果不是很明显
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    BOOL show= NO;
    if (show) {
        CGPoint point = [[touches anyObject] locationInView:self.view];
        [CATransaction begin];
        [CATransaction setAnimationDuration:2.0f];
        CAMediaTimingFunction *fun= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [CATransaction setAnimationTimingFunction:fun];
        self.image.layer.position = point;
        [CATransaction commit];
    }else{
        CGPoint point = [[touches anyObject] locationInView:self.view];
        // NO是会用弹簧动画  1是 距离/1 = 速度
        [UIView animateWithDuration:2.0f
                              delay:0.0f
             usingSpringWithDamping:YES
              initialSpringVelocity:1/*         距离 * 倍数 = 速度        */
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            self.image.layer.position = point;
        } completion:^(BOOL finished) {
            
        }];
    }

}

@end
