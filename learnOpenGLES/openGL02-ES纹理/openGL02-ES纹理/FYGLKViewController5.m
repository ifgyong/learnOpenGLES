//
//  FYGLKViewController.m
//  OpenGL01-GL的正方形
//
//  Created by Charlie on 2019/3/11.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "FYGLKViewController5.h"
#import "GLESUtils.h"
#import "GLESMath.h"
//
//  ViewController.m
//  OpenGL01-GL的正方形
//
//  Created by Charlie on 2019/3/8.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//
#define kShaderVertexChangeName @"vertexchange4"
#define kShaderVertexFName @"f2"
#define p0  {0.5, -0.5, 0.0f}
#define p1  {0.5, 0.5,  0.0f}
#define p2  {-0.5, 0.5, 0.0f}
#define p3  {-0.5, -0.5, 0.0f}
#define p4  {0,    0,   1.0f}

#define w00  {0.0, 0.0}
#define w01  {0.0, 1.0}
#define w10  {1.0, 0.0}
#define w11 {1.0, 1.0}
#define w55  {0.5, 0.5}

#define c0  {.0f,1.0f,1.0f,1.0f}//青色
#define c1  {1.0f,.0f,1.0f,1.0f}//紫色
#define c2  {.0f,1.0f,1.0f,1.0f}//青色
#define c3  {.0f,1.0f,.0f,1.0f}//绿色
#define c4  {1.0f,.0f,.0f,1.0f}//红色

#define pp0 {p0,c0,w10}
#define pp1 {p1,c1,w11}
#define pp2 {p2,c2,w01}
#define pp3 {p3,c3,w00}
#define pp4 {p4,c4,w55}

typedef struct {
    GLKVector3 positionCoords;  //点坐标
    GLKVector4 textureCoords;   //纹理 图片或者 颜色RGBA(Red,Ggreen,black,alpha)
    GLKVector2 vector;          //贴图 对应的坐标
}SceneVertex2;
static SceneVertex2 vertices2[] = {
    pp0,pp1,pp2,
    pp2,pp3,pp0,
    
    pp4,pp0,pp1,
    pp4,pp1,pp2,
    pp4,pp2,pp3,
    pp4,pp0,pp3,
};
@interface FYGLKViewController5 (){
    GLuint vertexBufferID;
    GLuint vertexBufferIDColor;
    GLuint program;
    
    GLKMatrix4 _transformMatrix;
    
    float value;
    
    GLint _p;
    GLint _Color;
    
    BOOL is_rotate_x;
    BOOL is_rotate_y;
    BOOL is_rotate_z;
    
}

@property (nonatomic) GLKBaseEffect *baseEffect;
@property (nonatomic) CAEAGLLayer *eaglayer;
@property (nonatomic,assign) CGFloat changeValue;
@end

@implementation FYGLKViewController5
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
    
    
    [self uploadTexture];
    //生成标示1个标识
    glGenBuffers(1, &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER,//初始化 buffer
                 sizeof(vertices2),//内存大小
                 vertices2,//数据赋值
                 GL_STATIC_DRAW);//GPU 内存
    
    self.changeValue = 1;
    _transformMatrix = GLKMatrix4Identity;
//    [self compileShader];
    [self uploadTexture];
    [self setup];
    
    
    [self addButtons];
}
- (void)addButtons{
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 100, 100, 50)];
    [btn setTitle:@"X" forState:0];
    [btn addTarget:self action:@selector(changeLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(150, 100, 100, 50)];
    [btn2 setTitle:@"Y" forState:0];
    btn2.tag = 1;
    [btn2 addTarget:self action:@selector(changeLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3=[[UIButton alloc]initWithFrame:CGRectMake(300, 100, 100, 50)];
    [btn3 setTitle:@"Z" forState:0];
    btn3.tag = 2;
    [btn3 addTarget:self action:@selector(changeLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
}
- (void)setup{
    
    //启用顶点缓存渲染操作
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //顶点渲染
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT, GL_FALSE,
                          sizeof(SceneVertex2),
                          NULL + offsetof(SceneVertex2, positionCoords));//NULL从当前绑定的顶点缓存的开始位置访问顶点数据
    //颜色
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE,
                          sizeof(SceneVertex2),
                          NULL+offsetof(SceneVertex2, textureCoords));
    //纹理渲染
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex2), NULL+offsetof(SceneVertex2, vector));
}
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];//
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);//清除背景
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);    
    [self update];
    [self draw];
}
- (void)update{
    static float rotate = 0.05;
    if (is_rotate_x) {
        _transformMatrix = GLKMatrix4Rotate(_transformMatrix, rotate, 0, 1, 0);
    }else if (is_rotate_y){
        _transformMatrix = GLKMatrix4Rotate(_transformMatrix, rotate, 1, 0, 0);
    }else if (is_rotate_z){
        _transformMatrix = GLKMatrix4Rotate(_transformMatrix, rotate, 0, 0, 1);
    }
    self.baseEffect.transform.modelviewMatrix = _transformMatrix;
}
- (void)draw{
    GLint count = sizeof(vertices2)/sizeof(SceneVertex2);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, count);
//    glDrawElements(GL_TRIANGLE_FAN, count, GL_UNSIGNED_BYTE, &indexs[0]);
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
    self.baseEffect.texture2d0.envMode = GLKTextureEnvModeModulate;
    
}
- (void)changeLocation:(UIButton *)sender{
    if (sender.tag == 0) {
        is_rotate_x = !is_rotate_x;
        is_rotate_y = NO;
        is_rotate_z = NO;
    }else if (sender.tag == 1){
        is_rotate_y = !is_rotate_y;
        is_rotate_x = NO;
        is_rotate_z = NO;
    }else if (sender.tag == 2){
        is_rotate_z = !is_rotate_z;
        is_rotate_x = NO;
        is_rotate_y = NO;
    }
}
@end
