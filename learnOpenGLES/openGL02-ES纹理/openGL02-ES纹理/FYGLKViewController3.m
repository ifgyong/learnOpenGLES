//
//  FYGLKViewController.m
//  OpenGL01-GL的正方形
//
//  Created by Charlie on 2019/3/11.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "FYGLKViewController3.h"
#import "GLESMath.h"
#import "GLESUtils.h"
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
    
    KSMatrix4 _matrix4;
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
//    定义的属性需要和系统的绑定一起  否则识别不了
    glBindAttribLocation(programHandle, GLKVertexAttribPosition, "Position");
    glBindAttribLocation(programHandle, GLKVertexAttribColor, "SourceColor");
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
    [self update];
    [self draw];
    // 更新uniform颜色

//    float timeValue = sin(arc4random()%10/3.3f);
//    float greenValue = sin(timeValue) / 2.0f + 0.5f;

}
- (void)setup{
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
    self.changeValue = self.changeValue + 0.1;
    glUseProgram(program); //声明使用的program
    GLuint variable= glGetUniformLocation(program, "valueChange");
    glUniform1f(variable,(CGFloat)self.changeValue);
    GLuint variable2= glGetUniformLocation(program, "SourceColor2");
    float s = sin(self.changeValue);
    glUniform4f(variable2, s, 1-s, fabsf(s-1), s);
    
    ksMatrixLoadIdentity(&_matrix4);//初始化
    ksRotate(&_matrix4, self.changeValue, 0, 1, 0);
    ksRotate(&_matrix4, self.changeValue, 1, 0, 0);
    
    //maritx
    
    GLuint mar = glGetUniformLocation(program, "maritx");
    glUniformMatrix4fv(mar, 1, GL_FALSE,
                       (GLfloat *)&_matrix4.m[0][0]);
    
}
- (void)draw{
    //绘图
    GLuint count = sizeof(vertices2)/sizeof(SceneVertex2);
    glDrawArrays(GL_TRIANGLES,0, count);
}

@end
