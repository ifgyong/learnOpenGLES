//
//  FYGLKViewController.m
//  OpenGL01-GL的正方形
//
//  Created by Charlie on 2019/3/11.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "FYGLKViewController.h"

//
//  ViewController.m
//  OpenGL01-GL的正方形
//
//  Created by Charlie on 2019/3/8.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

typedef struct {
    GLKVector3 positionCOords;
}ScenVertex;
@interface FYGLKViewController (){
    GLuint vertexBufferID;
}
@property (nonatomic) GLKBaseEffect *baseEffect;
@end
static const ScenVertex vertices[]= {
    {{ -0.5f,  -0.5f,  0.0f}},               // bottom left
    {{0.5f,   -0.5f,   0.0f}},                // bottom right
    {{ 0.0f,  0.5f,   0.0f}},
    // top left
    // top right
};
@implementation FYGLKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    GLKView *view=(GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view 不是GLKView");
    
    view.context =[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    self.baseEffect =[[GLKBaseEffect alloc]init];
    
    
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    glClearColor(0, 0, 0, 1);//背景颜色
    //生成标示1个标识
    glGenBuffers(1, &vertexBufferID);
    //绑定缓存  GL_ARRAY_BUFFER 顶点属性的图形 GL_ELEMENT_ARRAY_BUFFER其他类型的图形
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    //赋值缓存到缓存中
    glBufferData(GL_ARRAY_BUFFER,//初始化 buffer
                 sizeof(vertices),//内存大小
                 vertices,//数据赋值
                 GL_STATIC_DRAW);//GPU 内存
    
    
    
    
}
- (void)viewDidUnload{
    GLKView *view=(GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view 不是GLKView");
    [EAGLContext setCurrentContext:view.context];
    if (0 != vertexBufferID) {
        glDeleteBuffers(1, &vertexBufferID);//删除标识
        vertexBufferID = 0;
    }
    //没有加载成功就删除当前上下文
    view.context = nil;
    [EAGLContext setCurrentContext:nil];
}
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];//
    
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    //启用顶点缓存渲染操作
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //3是步长  每3个数字是一组数据 GL_FLOAT是数据类型 GL_FALSE小数位置是否可变
//   sizeof(ScenVertex)是每一组数据的内存长度 NULL是从当前顶点开始
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE,sizeof(ScenVertex), NULL);//NULL从当前绑定的顶点缓存的开始位置访问顶点数据
    //一共4个点 为 0 1 2 3。
    // GL_TRIANGLE_STRIP 模式下 0 1 2 3,4个点，构成 012,123,2个三角形 组成的图案。 每连续3个点构成三角形 ，所有三角形加一起组成总的图案。
    // GL_TRIANGLE_FAN 是012,023一共2个三角形，index为0和连续两个点组成2个三角形，这两个三角形组成总图案。
//GL_TRIANGLES 每3个数据为一组，0-2为一个三角形 3-5为一个三角形。
    glDrawArrays(GL_TRIANGLE_FAN, 0/*顶点的位置*/, 3/*顶点数量*/);
    //3个顶点 画了1个三角形 组成的一个长方形
}



@end
