//
//  NSObject+FY.m
//  openGL02-ES纹理
//
//  Created by Charlie on 2019/3/13.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "NSObject+FY.h"

@implementation NSObject (FY)
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
