//
//  FYTextLayerViewController.m
//  FYCALayers
//
//  Created by Charlie on 2019/3/6.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "FYTextLayerViewController.h"
#import <CoreText/CoreText.h>

@interface FYTextLayerViewController ()

@end

@implementation FYTextLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self textLayer];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)textLayer{
    CATextLayer *textLayer=[[CATextLayer alloc]init];
    textLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    textLayer.frame = CGRectMake(50, 100, 200, 100);
    [self.view.layer addSublayer:textLayer];
    textLayer.foregroundColor = [UIColor redColor].CGColor;
    //两边对齐 这个label 两边对齐效果不是很好，用textLayer解决这个问题
    textLayer.alignmentMode = kCAAlignmentJustified;
    //高清 显示 其实就是屏幕的倍数
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.wrapped = YES;
    UIFont *font=[UIFont systemFontOfSize:15];
    CFStringRef fontStringRef = (__bridge CFStringRef)(font.fontName);
    CGFontRef fontRef = CGFontCreateWithFontName(fontStringRef);
    textLayer.font = fontRef;
    textLayer.fontSize = 15;
    CGFontRelease(fontRef);
    
    
    NSMutableAttributedString *text =[[NSMutableAttributedString alloc] initWithString:@"我是textLayer绘画的layer我是textLayer绘画的layer我是textLayer绘画的layer我是textLayer绘画的layer我是textLayer绘画的layer我是textLayer绘画的layer我是textLayer绘画的layer" ];

    textLayer.string = text;
    
}

@end
