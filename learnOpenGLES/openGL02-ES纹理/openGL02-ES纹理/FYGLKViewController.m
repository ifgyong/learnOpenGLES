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
    GLKVector3 positionCoords;
}ScenVertex;
//顶点数据，前三个是顶点坐标（x、y、z轴），后面两个是纹理坐标（x，y）
//顶点数据
typedef struct {
    GLKVector3 positionCoords;  //点坐标
    GLKVector2 textureCoords;   //纹理
}SceneVertex2;
@interface FYGLKViewController (){
    GLuint vertexBufferID;
}
@property (nonatomic) GLKBaseEffect *baseEffect;
@end

//矩形的六个顶点
static const SceneVertex2 vertices2[] = {
    {{1, -1, 0.0f,},{1.0f,0.0f}}, //右下
    {{1, 1,  0.0f},{1.0f,1.0f}}, //右上
    {{-1, 1, 0.0f},{0.0f,1.0f}}, //左上
    
    {{1, -1, 0.0f},{1.0f,0.0f}}, //右下
    {{-1, 1, 0.0f},{0.0f,1.0f}}, //左上
    {{-1, -1, 0.0f},{0.0f,0.0f}}, //左下
};
@implementation FYGLKViewController
-(void)dealloc{
    [EAGLContext setCurrentContext:nil];
    if (vertexBufferID !=0) {
        glDeleteBuffers(1, &vertexBufferID);
        vertexBufferID = 0;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    GLKView *view=(GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view 不是GLKView");
    
    view.context =[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;//
    [EAGLContext setCurrentContext:view.context];
    self.baseEffect =[[GLKBaseEffect alloc]init];
    
    
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    [self uploadTexture];
    glClearColor(1, 1, 1, 1);//背景颜色
    //生成标示1个标识
    glGenBuffers(1, &vertexBufferID);
    //绑定缓存  GL_ARRAY_BUFFER 顶点属性的图形 GL_ELEMENT_ARRAY_BUFFER其他类型的图形
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    //赋值缓存到缓存中
    glBufferData(GL_ARRAY_BUFFER,//初始化 buffer
                 sizeof(vertices2),//内存大小
                 vertices2,//数据赋值
                 GL_STATIC_DRAW);//GPU 内存
    
    [self setup];
}
- (void)setup{
    //启用顶点缓存渲染操作
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //3是步长  每3个数字是一组数据 GL_FLOAT是数据类型 GL_FALSE小数位置是否可变
    //   sizeof(ScenVertex)是每一组数据的内存长度 NULL是从当前顶点开始
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT, GL_FALSE,
                          sizeof(SceneVertex2),
                          NULL + offsetof(SceneVertex2, positionCoords));//NULL从当前绑定的顶点缓存的开始位置访问顶点数据
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);// 纹理
    glVertexAttribPointer(GLKVertexAttribTexCoord0,
                          2,
                          GL_FLOAT, GL_FALSE,
                          sizeof(SceneVertex2),
                          NULL+offsetof(SceneVertex2, textureCoords));
    
}
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];//
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);//清除背景
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    glDrawArrays(GL_TRIANGLES, 0/*顶点的位置*/, 6/*顶点数量*/);
}
- (void)uploadTexture{
    UIImage *image=[UIImage imageNamed:@"2.jpg"];
    //设定坐标方向 1是左下角是 (0,0)，右上角 (1,1)
    NSDictionary *options=[NSDictionary dictionaryWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *info=[GLKTextureLoader textureWithCGImage:image.CGImage
                                                      options:options
                                                        error:nil];
    self.baseEffect.texture2d0.enabled = GL_TRUE;
    self.baseEffect.texture2d0.name= info.name;
    self.baseEffect.texture2d0.target = info.target;
    
}


@end
