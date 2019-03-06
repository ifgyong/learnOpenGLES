//
//  ViewController.m
//  DrowShadow
//
//  Created by Charlie on 2019/3/4.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
{
    UIView *_subView;
    BOOL _isAdd;
    NSInteger _type;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _subView=[[UIView alloc]initWithFrame:CGRectMake(20, 20, kAppViewWidth-40, kAppViewWidth - 40)];
    [self.view addSubview:_subView];
    [self.view sendSubviewToBack:_subView];
    
    [self addImages];
    
    CATransform3D transform= CATransform3DIdentity;
    transform = CATransform3DMakeRotation(-M_PI_4/2.0, 1, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    _subView.layer.sublayerTransform = transform;
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint locaiton = [[touches anyObject] locationInView:self.view];
    CATransform3D transform= CATransform3DIdentity;
    CGFloat xRotation = (locaiton.x/kAppViewWidth-1) * M_PI ;
    CGFloat yRotation = (locaiton.y/kAppViewHeight-1) *M_PI ;
    transform = CATransform3DMakeRotation(-yRotation, 1, 0, 0);
    transform = CATransform3DRotate(transform, xRotation, 0, 1, 0);
    _subView.layer.sublayerTransform = transform;
}
- (void)addImages{
    
    [self addImageWithFrame:CGRectMake(0, 100, 100, 100)
                  layerRect:CGRectMake(0, 0, 0.5, 0.5)
                      index:1];//左上
    [self addImageWithFrame:CGRectMake(105, 100, 100, 100)
                  layerRect:CGRectMake(0.5, 0, 0.5, 0.5)
                      index:2];
    [self addImageWithFrame:CGRectMake(0, 205, 100, 100)
                  layerRect:CGRectMake(0, 0.5, 0.5, 0.5)
                      index:3];
    [self addImageWithFrame:CGRectMake(105, 205, 100, 100)
                  layerRect:CGRectMake(0.5, 0.5, 0.5, 0.5)
                      index:4];
    [self addImageWithFrame:CGRectMake(105, 205, 100, 100)
                  layerRect:CGRectMake(0.5, 0, 0.5, 0.5)
                      index:5];
    [self addImageWithFrame:CGRectMake(105, 205, 100, 100)
                  layerRect:CGRectMake(0, 0.5, 0.5, 0.5)
                      index:6];
}
-(void)addImageWithFrame:(CGRect)frame layerRect:(CGRect)rect index:(NSInteger)index{
    frame = CGRectMake(100, 100, 100, 100);
    UIImage * image = [UIImage imageNamed:@"3.jpg"];
    UIView *view = _subView;
    CALayer *layer =[[CALayer alloc]init];
    layer.frame = frame;
    [view.layer addSublayer:layer];
    layer.contents = CFBridgingRelease(image.CGImage);
    layer.contentsGravity = kCAGravityCenter;
    layer.contentsScale = [[UIScreen mainScreen] scale];//按照屏幕的比例显示
    layer.masksToBounds = YES;//超出边界剪切
    layer.contentsRect = rect; //{0,0,1,1}是全部 {0，0，0.5，0.5}是展示1/4
    //    view.layer.anchorPoint = CGPointMake(0, 0);//锚点默认 0.5 0.5 改为0.0 frame 根据这个锚点更新frame
    //*********************这是2D变换*********************************
    //旋转90°
    //    CGAffineTransform transform= CGAffineTransformMakeRotation(-M_PI_2);
    //    //缩小1/4
    //    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    //    //移动 x:110 y:0
    //    transform = CGAffineTransformTranslate(transform, 110, 0);
    //    view.layer.affineTransform = transform;
    
    
    //     //*********************这是3D变换*********************************
    //旋转45°
    CATransform3D transform3d = CATransform3DMakeTranslation(0, 100, 0);
    transform3d.m34= -1.0f/500.0f;
    // 绕 0，1 X轴旋转 45 °
    switch (index) {
        case 1:
            //z 轴 移动50
            transform3d = CATransform3DMakeTranslation(0, 0, 50);
            break;
        case 2:
            //x 轴 移动50 Y轴旋转90°
            transform3d = CATransform3DMakeTranslation(50, 0, 0);
            transform3d = CATransform3DRotate(transform3d, M_PI_2, 0, 1, 0);
            
            break;
        case 3:
            //x 轴 移动-50 Y轴旋转90°
            transform3d = CATransform3DMakeTranslation(-50, 0, 0);
            transform3d = CATransform3DRotate(transform3d, -M_PI_2, 0, 1, 0);
            
            break;
        case 4:
            //y 轴 移动50 x轴旋转90°
            transform3d = CATransform3DMakeTranslation(0, 50, 0);
            transform3d = CATransform3DRotate(transform3d, M_PI_2, 1, 0, 0);
            
            break;
        case 5:
            //y 轴 移动-50 x轴旋转90°
            transform3d = CATransform3DMakeTranslation(0, -50, 0);
            transform3d = CATransform3DRotate(transform3d, M_PI_2, 1, 0, 0);
            
            break;
        case 6:
            transform3d = CATransform3DMakeTranslation(0, 0, -50);
            break;
        default:
            break;
    }
    layer.transform = transform3d;
    
    // 绕 1，0 Y轴旋转 45 °
    //    transform3d = CATransform3DRotate(transform3d, M_PI_4, 1, 0, 0);
    // 绕 0，0,1 Z轴旋转 45 °
    //    transform3d = CATransform3DRotate(transform3d, M_PI_4, 0, 0, 1);
    //    [UIView animateWithDuration:1.0f
    //                     animations:^{
    //        view.layer.transform = transform3d;
    //    }];
    //    [self.view addSubview:view];
    
    
    //    UIImage *image2=[UIImage imageNamed:@"1.png"];
    //    CALayer *maskLayer=[CALayer layer];
    //    maskLayer.frame = view.bounds;
    //    maskLayer.contents = (__bridge id _Nullable)(image2.CGImage);
    //    view.layer.mask = maskLayer; // m以mask 为滤镜来过滤 layer的 图像，mask是无规则的镜子，透过镜子看到的 才是最终版本的 layer图层。
    
    layer.magnificationFilter = kCAFilterNearest;
}

@end

