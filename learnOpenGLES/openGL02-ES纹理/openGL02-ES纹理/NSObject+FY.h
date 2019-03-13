//
//  NSObject+FY.h
//  openGL02-ES纹理
//
//  Created by Charlie on 2019/3/13.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (FY)
- (GLuint)compileShader:(NSString *)shaderName withType:(GLenum)shaderType;
@end

NS_ASSUME_NONNULL_END
