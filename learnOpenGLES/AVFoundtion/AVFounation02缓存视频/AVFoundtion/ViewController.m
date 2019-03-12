//
//  ViewController.m
//  AVFoundtion
//
//  Created by Charlie on 2019/3/11.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic,strong) AVCaptureSession       *session;
@property (nonatomic) AVCaptureDevice               *videoDevice;
@property (nonatomic) AVCaptureDeviceInput          *videoInput;
@property (nonatomic) AVCaptureVideoDataOutput      *videoOutput;
@property (nonatomic) AVCaptureConnection           *videmoConnection;
@property (nonatomic) AVCaptureVideoPreviewLayer    *previerLayer;

@property (nonatomic,strong) dispatch_queue_t queue;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@end

@implementation ViewController

-(dispatch_queue_t)queue{
    if (_queue == nil) {
        _queue=dispatch_queue_create("com.create.video", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVideo];
    
}
- (void)setupVideo{
    self.session=[[AVCaptureSession alloc]init];
//    新建 video类型的设备
    self.videoDevice=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //新建 输入流
    self.videoInput=[AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice
                                                          error:nil];
    //输出流
    self.videoOutput=[[AVCaptureVideoDataOutput alloc]init];
    //设置输出流代理
    [self.videoOutput setSampleBufferDelegate:self
                                        queue:self.queue];
    //显示layer
    self.previerLayer =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previerLayer.frame =self.view.bounds;
    [self.view.layer addSublayer:self.previerLayer];
    [self.view bringSubviewToFront:self.stackView];
    
    //新建链接
    self.videmoConnection=[self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    //开始配置 session
    [self.session beginConfiguration];
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.videoOutput]) {
        [self.session addOutput:self.videoOutput];
    }
    if ([self.session canAddConnection:self.videmoConnection]) {
        [self.session addConnection:self.videmoConnection];
    }
    //配置结束
    [self.session commitConfiguration];
    
}

- (IBAction)start:(id)sender {
    //启动
    if ([self.session isRunning] == NO) {
        [self.session startRunning];
    }
}
- (IBAction)stop:(id)sender {
    //停止
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
}
- (IBAction)changeCamer:(id)sender {
    [self updateCurrentPosition];
}
-(void)updateCurrentPosition{
    //切换摄像头
    AVCaptureDevice *device = nil;

    AVCaptureDevicePosition changePosition = AVCaptureDevicePositionUnspecified;
    if (self.videoInput.device.position == AVCaptureDevicePositionBack) {
        changePosition = AVCaptureDevicePositionFront;
    }else {
        changePosition = AVCaptureDevicePositionBack;
    }
    device=[AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                              mediaType:AVMediaTypeVideo
                                               position:changePosition];
    //新建输入device
    AVCaptureDeviceInput* videoInput=[AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //重新配置 session
    [self.session beginConfiguration];
    [self.session removeInput:self.videoInput];
    if ([self.session canAddInput:videoInput]) {
        self.videoInput= videoInput;
        [self.session addInput:self.videoInput];
    }
    [self.session commitConfiguration];
}

@end
