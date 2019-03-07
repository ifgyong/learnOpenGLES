//
//  FYAVplayerLayerViewController.m
//  FYCALayers
//
//  Created by Charlie on 2019/3/7.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "FYAVplayerLayerViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface FYAVplayerLayerViewController ()

@end

@implementation FYAVplayerLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLayer];
}
- (void)addLayer{
    
    //播放网络视频
    AVPlayerItem *item=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://www.shscma.com/upload/video/79e2a9086d2089b5ac2d2174768ca1c7.mp4"]];
    AVPlayer *player=[[AVPlayer alloc]initWithPlayerItem:item];
    
    
    
    //构造 播放器layer
    AVPlayerLayer *layer=[AVPlayerLayer playerLayerWithPlayer:player];
    //    layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
    layer.frame = CGRectMake(100, 100, 200, 200);
    //添加播放器
    [self.view.layer addSublayer:layer];
    layer.maskedCorners = 10.0f;
    layer.borderColor = [UIColor redColor].CGColor;
    layer.borderWidth = 2.0f;
//    layer.masksToBounds = YES;
    
    CATransform3D trans=CATransform3DIdentity;
    trans.m34 = -1/500;
    trans = CATransform3DRotate(trans, M_PI_4, 1, 1, 0);
    layer.transform = trans;
    
    
    [player play];
}

@end
