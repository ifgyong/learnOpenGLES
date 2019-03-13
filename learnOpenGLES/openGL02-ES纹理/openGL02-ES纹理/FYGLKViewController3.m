//
//  FYGLKViewController.m
//  OpenGL01-GL的正方形
//
//  Created by Charlie on 2019/3/11.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "FYGLKViewController3.h"

//
//  ViewController.m
//  OpenGL01-GL的正方形
//
//  Created by Charlie on 2019/3/8.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

typedef struct {
    GLKVector3 positionCoords;  //点坐标
    GLKVector4 textureCoords;   //纹理 图片或者 颜色RGBA(Red,Ggreen,black,alpha)
}SceneVertex2;
//矩形的六个顶点
static const SceneVertex2 vertices2[] = {
    {{0.7, -0.7, 0.0f},{1.0f, 0.0f, 1.0f,1.0f}}, //右下
    {{0.7, 0.7,  0.0f},{1.0f, 0.0f, 1.0f,1.0f}}, //右上
    {{-0.7, 0.7, 0.0f},{1.0f, 1.0f, 0.0f,1.0f}}, //左上
    
    {{0.7, -0.7, 0.0f},{1.0f, 0.0f, 1.0f,1.0f}}, //右下
    {{-0.7, 0.7, 0.0f},{1.0f, 1.0f, 0.0f,1.0f}}, //左上
    {{-0.7, -0.7, 0.0f},{1.0f,0.0f, 1.0f,1.0f}}, //左下 白色
};

@interface FYGLKViewController3 (){
    GLuint vertexBufferID;
    GLuint program;
    
    GLuint _color;
    GLuint _p;
}

@property (nonatomic) GLKBaseEffect *baseEffect;
@property (nonatomic) CAEAGLLayer *eaglayer;
@property (nonatomic,assign) CGFloat changeValue;
@end


@implementation FYGLKViewController3
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
    
//    [self uploadTexture];
    glGenBuffers(1, &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER,//初始化 buffer
                 sizeof(vertices2),//内存大小
                 vertices2,//数据赋值
                 GL_STATIC_DRAW);//GPU 内存
    [self compileShader];
    [self setup];
}


/**
 创建着色器并链接到坐标上
 */
- (void)compileShader{
    GLuint certex=[self compileShader:@"vertexchange2"
                             withType:GL_VERTEX_SHADER];
    GLuint fragmentShader=[self compileShader:@"f2"
                                     withType:GL_FRAGMENT_SHADER];
    GLuint programHandle= glCreateProgram();
    program = programHandle;
    glAttachShader(programHandle, certex);
    glAttachShader(programHandle, fragmentShader);
    
    glLinkProgram(programHandle);
    
    glDeleteShader(certex);
    glDeleteShader(fragmentShader);
    
    GLint linksuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linksuccess);
    if (linksuccess == GL_FALSE) {
        GLchar messages[256];
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"着色器程序:%@", messageString);
        exit(1);
    }
    glUseProgram(programHandle);
    _p      = glGetAttribLocation(program, "Position");
    _color  = glGetAttribLocation(program, "SourceColor");
    
    

}
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];//
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);//清除背景
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
//    [self update];
//    int vertexColorLocation = glGetUniformLocation(program, "ourColor");
//    glUniform4f(vertexColorLocation, 0.0f, 1.0f, 0.0f, 1.0f);
    [self draw];
    // 更新uniform颜色

//    float timeValue = sin(arc4random()%10/3.3f);
//    float greenValue = sin(timeValue) / 2.0f + 0.5f;

}
- (void)setup{
    
    //启用顶点缓存渲染操作
//    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //3是步长  每3个数字是一组数据 GL_FLOAT是数据类型 GL_FALSE小数位置是否可变
    //   sizeof(ScenVertex)是每一组数据的内存长度 NULL是从当前顶点开始
    glVertexAttribPointer(_p,
                          3,
                          GL_FLOAT, GL_FALSE,
                          sizeof(SceneVertex2),
                          NULL + offsetof(SceneVertex2, positionCoords));
    glEnableVertexAttribArray(_p);

    
    glVertexAttribPointer(_color,
                          4, GL_FLOAT, GL_FALSE,
                          sizeof(SceneVertex2),
                          NULL+offsetof(SceneVertex2, positionCoords));
    glEnableVertexAttribArray(_color);

}
- (void)update{
    //更新改变的value
    self.changeValue = self.changeValue + 0.02;
    if (self.changeValue > M_PI) {
        self.changeValue = self.changeValue - M_PI;
    }
//    GLuint variable= glGetUniformLocation(program, "change");
    
//    glUniform1f(variable,(CGFloat)self.changeValue);
}
- (void)draw{
    //给shader的全局变量传值计算出来frame
//    GLuint color= glGetUniformLocation(program, "color");
//    float ss =sin(self.changeValue);
//    float cc = cos(self.changeValue);
//    float tt = 1 - cc;
//    glUniform4f(color, ss, cc, tt, 1.0f);
    //绘图
    GLuint count = sizeof(vertices2)/sizeof(SceneVertex2);
    glDrawArrays(GL_TRIANGLES,0, count);
}

@end
