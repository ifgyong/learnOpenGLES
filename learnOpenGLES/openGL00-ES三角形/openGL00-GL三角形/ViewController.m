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
    if (sender.tag == 0) {
        FYGLKViewController *view=[[FYGLKViewController alloc]init];
        [self.navigationController pushViewController:view animated:YES];
    }else if (sender.tag == 1){
        FYLineViewController *line=[[FYLineViewController alloc]init];
        [self.navigationController pushViewController:line animated:YES];
    }
   
}


@end
