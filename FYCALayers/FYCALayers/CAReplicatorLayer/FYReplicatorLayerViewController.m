//
//  FYReplicatorLayerViewController.m
//  FYCALayers
//
//  Created by Charlie on 2019/3/6.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "FYReplicatorLayerViewController.h"

@interface FYReplicatorLayerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation FYReplicatorLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLayer];
}
- (void)addLayer{
    CAReplicatorLayer *layer=[CAReplicatorLayer layer];
    layer.backgroundColor =[[UIColor redColor] CGColor];
//    layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"1.jpg"] .CGImage);
    layer.frame = CGRectMake(100, 100, 200, 200);
    [self.view.layer addSublayer:layer];
    layer.instanceCount = 10;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 200, 0);
    transform = CATransform3DRotate(transform, M_PI/5.0f, 0, 0, 1);
    transform = CATransform3DScale(transform, 1, -1, 0);
    
    layer.instanceTransform =transform;
//    layer.instanceAlphaOffset = -0.6;
    
    
    layer.instanceRedOffset = -0.1;
    layer.instanceBlueOffset = -0.1;
    
    CALayer *ll=[CALayer layer];
    ll.frame = CGRectMake(0, 0, 100, 100);
    ll.backgroundColor = [UIColor whiteColor].CGColor;
    [layer addSublayer:ll];
}

@end
