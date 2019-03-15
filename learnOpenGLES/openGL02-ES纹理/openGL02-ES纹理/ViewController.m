//
//  ViewController.m
//  openGL02-ES纹理
//
//  Created by Charlie on 2019/3/12.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "ViewController.h"
#import "FYGLKViewController2.h"
#import "FYGLKViewController3.h"
#import "FYGLKViewController4.h"
#import "FYGLKViewController.h"
#import "FYGLKViewController5.h"
#import "FYGLKEffectsViewController.h"
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
        [self.navigationController pushViewController:view
                                             animated:YES];
    }else if(sender.tag == 1) {
        FYGLKViewController2 *view=[[FYGLKViewController2 alloc]init];
        [self.navigationController pushViewController:view
                                             animated:YES];
    }else if (sender.tag == 2){
        FYGLKViewController3 *view=[[FYGLKViewController3 alloc]init];
        [self.navigationController pushViewController:view
                                             animated:YES];
    }else if (sender.tag == 3){
        FYGLKViewController4 *vc=[FYGLKViewController4 new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 4){
         FYGLKViewController5 *vc=[FYGLKViewController5 new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 5){
        FYGLKEffectsViewController *vc=[FYGLKEffectsViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }


}

@end
