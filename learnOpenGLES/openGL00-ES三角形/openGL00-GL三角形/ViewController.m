//
//  ViewController.m
//  openGL00-GL三角形
//
//  Created by Charlie on 2019/3/12.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "ViewController.h"
#import "FYGLKViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)push:(UIButton *)sender {
    FYGLKViewController *view=[[FYGLKViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}


@end
