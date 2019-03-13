//
//  FYGLKViewController.m
//  OpenGL01-GL的正方形
//
//  Created by Charlie on 2019/3/11.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "FYGLKViewController4.h"

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
    GLKVector2 vector;          //贴图 对应的坐标
}SceneVertex2;
//矩形的六个顶点
static const SceneVertex2 vertices2[] = {
    {{0.5, -0.5, 0.0f,},{1.0f,1.0f,1.0f,1.0f},  {1.0,.0f}}, //右下
    {{0.5, 0.5,  0.0f},{1.0f,.0f,1.0f,1.0f},    {1.0,1.0f}}, //右上
    {{0, 0, 0.0f},{0.0f,.0f,.0f,1.0f},          {0.5f,.5f}}, //中间顶点
    {{-0.5, 0.5, 0.0f},{1.0f,1.0f,0.0f,1.0f},   {.0,1.0f}}, //左上

    {{-0.5, -0.5, 0.0f},{1.0f,.0f,1.0f,1.0f},   {0.0,.0f}}, //左下 白色
    {{0.5, -0.5, 0.0f},{.0f,1.0f,1.0f,1.0f},   {1.0,.0f}}, //右下
    {{0, 0, 0.0f},{0.0f,.0f,.0f,1.0f},          {0.5f,0.5f}}, //中间顶点
};
@interface FYGLKViewController4 (){
    GLuint vertexBufferID;
    GLuint program;
    
    GLKMatrix4 transformMatrix;
    
    float value;
    
}

@property (nonatomic) GLKBaseEffect *baseEffect;
@property (nonatomic) CAEAGLLayer *eaglayer;
@property (nonatomic,assign) CGFloat changeValue;
@end


@implementation FYGLKViewController4
-(void)dealloc{
    [EAGLContext setCurrentContext:nil];
    if (vertexBufferID !=0) {
        glDeleteBuffers(1, &vertexBufferID);
        vertexBufferID = 0;
    }
    self.baseEffect = nil;
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
    [self uploadTexture];
    
    transformMatrix = GLKMatrix4Identity;
}
- (void)setup{
    
    //启用顶点缓存渲染操作
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //3是步长  每3个数字是一组数据 GL_FLOAT是数据类型 GL_FALSE小数位置是否可变
    //   sizeof(ScenVertex)是每一组数据的内存长度 NULL是从当前顶点开始
    //顶点渲染
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT, GL_FALSE,
                          sizeof(SceneVertex2),
                          NULL + offsetof(SceneVertex2, positionCoords));//NULL从当前绑定的顶点缓存的开始位置访问顶点数据
    //颜色
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(SceneVertex2), NULL+offsetof(SceneVertex2, textureCoords));
    //纹理渲染
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex2), NULL+offsetof(SceneVertex2, vector));
    
}
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];//
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);//清除背景
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);    
    
    
//    glUseProgram(program);
    
//    GLuint transformUniformLocation = glGetUniformLocation(program, "change");
//    glUniformMatrix4fv(transformUniformLocation, 1, 0, transformMatrix.m);

    [self draw];
}
- (void)update{
    value += 0.1;
    if (value > 1) {
        value -= 1;
    }
    // 旋转
//    GLKMatrix4 rotateMatrix = GLKMatrix4MakeRotation(value , 0, 0, 0.0);
    
    // 平移
//    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(0, 0, -3.0);
    
    // 透视投影
    float aspect = self.view.frame.size.width / self.view.frame.size.height;
    GLKMatrix4 perspectiveMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 20.0);
    // GLKMathDegreesToRadians(90) 是将角度转为弧度
    transformMatrix = perspectiveMatrix;
    //    translateMatrix = GLKMatrix4Multiply(perspectiveMatrix, translateMatrix);
}
- (void)draw{
    //渲染
    GLuint count = sizeof(vertices2)/sizeof(SceneVertex2);
    glDrawArrays(GL_TRIANGLE_STRIP, 0/*顶点的位置*/, count/*顶点数量*/);
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
//    self.baseEffect.texture2d0.envMode = GLKTextureEnvModeModulate;
    
}
/**
 创建着色器并链接到坐标上
 */
- (void)compileShader{
    GLuint certex=[self compileShader:@"vertexchange" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader=[self compileShader:@"f2" withType:GL_FRAGMENT_SHADER];
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
    glGetAttribLocation(programHandle, "Position");
}
@end
