//
//  FYGLKViewController.m
//  OpenGL01-GL的正方形
//
//  Created by Charlie on 2019/3/11.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "FYGLKViewController2.h"

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
    {{0.7, -0.7, 0.0f,},{1.0f,1.0f,1.0f,1.0f}}, //右下
    {{0.7, 0.7,  0.0f},{1.0f,.0f,1.0f,1.0f}}, //右上
    {{-0.7, 0.7, 0.0f},{1.0f,1.0f,0/255.0f,1.0f}}, //左上
    
    {{0.7, -0.7, 0.0f},{1.0f,1.0f,1.0f,1.0f}}, //右下
    {{-0.7, 0.7, 0.0f},{1.0f,1.0f,0/255.0f,1.0f}}, //左上
    {{-0.7, -0.7, 0.0f},{1.0f,.0f,1.0f,1.0f}}, //左下 白色
};

@interface FYGLKViewController2 (){
    GLuint vertexBufferID;
    GLuint program;
}

@property (nonatomic) GLKBaseEffect *baseEffect;
@property (nonatomic) CAEAGLLayer *eaglayer;
@property (nonatomic,assign) CGFloat changeValue;
@end


@implementation FYGLKViewController2
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
    //生成标示1个标识
    glGenBuffers(1, &vertexBufferID);
    //绑定缓存  GL_ARRAY_BUFFER 顶点属性的图形 GL_ELEMENT_ARRAY_BUFFER其他类型的图形
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    //赋值缓存到缓存中
    glBufferData(GL_ARRAY_BUFFER,//初始化 buffer
                 sizeof(vertices2),//内存大小
                 vertices2,//数据赋值
                 GL_STATIC_DRAW);//GPU 内存
    [self compileShader];
    [self setup];
}
- (void)setup{
    
    
    GLuint variable= glGetUniformLocation(program, "change");
    glUniform1f(variable,(CGFloat)self.changeValue);
    
    //启用顶点缓存渲染操作
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //3是步长  每3个数字是一组数据 GL_FLOAT是数据类型 GL_FALSE小数位置是否可变
    //   sizeof(ScenVertex)是每一组数据的内存长度 NULL是从当前顶点开始
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT, GL_FALSE,
                          sizeof(SceneVertex2),
                          NULL + offsetof(SceneVertex2, positionCoords));//NULL从当前绑定的顶点缓存的开始位置访问顶点数据
    
    //
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(SceneVertex2), NULL+offsetof(SceneVertex2, textureCoords));
    
}

/**
 创建着色器并链接到坐标上
 */
- (void)compileShader{
    GLuint certex=[self compileShader:@"vertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader=[self compileShader:@"f" withType:GL_FRAGMENT_SHADER];
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
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];//
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);//清除背景
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
//    glUseProgram(program); 没使用着色器
    
    [self draw];
}

- (void)draw{
    //渲染
    GLuint count = sizeof(vertices2)/sizeof(SceneVertex2);
    glDrawArrays(GL_TRIANGLES, 0/*顶点的位置*/, count/*顶点数量*/);
//    glDrawElements(GL_TRIANGLES, count, GL_UNSIGNED_BYTE, 0);
}
/**
 读取着色器文件

 @param shaderName name
 @param shaderType 类型
 @return 着色器
 */
- (GLuint)compileShader:(NSString *)shaderName withType:(GLenum)shaderType {
    NSString *path=[[NSBundle mainBundle] pathForResource:shaderName
                                                   ofType:@"glsl"];
    NSError *error= nil;
    NSString *shaderString =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@",error);
        exit(1);
    }
    
    GLuint shader= glCreateShader(shaderType);
    const char * shaderStringUTF8=[shaderString UTF8String];
    int stringLength = (int)strlen(shaderStringUTF8);
    glShaderSource(shader,1, &shaderStringUTF8, &stringLength);
    glCompileShader(shader);
    
    GLint compilSuccess;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compilSuccess);
    if (compilSuccess == GL_FALSE) {
        GLchar message [256];
        NSString *message_OC=[NSString stringWithUTF8String:message];
        NSLog(@"%@",message_OC);
        exit(1);
    }
    return shader;
}


@end
