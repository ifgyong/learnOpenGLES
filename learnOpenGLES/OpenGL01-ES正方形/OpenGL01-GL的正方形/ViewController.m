//
//  ViewController.m
//  OpenGL01-GL的正方形
//
//  Created by Charlie on 2019/3/8.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "ViewController.h"
#import "FYGLKViewController.h"
typedef struct {
    GLKVector3 positionCOords;
}ScenVertex;
@interface ViewController (){
    GLuint vertexBufferID;
}
@property (nonatomic) GLKBaseEffect *baseEffect;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)pushVC:(UIButton *)sender {
    FYGLKViewController *glk=[FYGLKViewController new];
    [self.navigationController pushViewController:glk
                                         animated:YES];
}


@end
