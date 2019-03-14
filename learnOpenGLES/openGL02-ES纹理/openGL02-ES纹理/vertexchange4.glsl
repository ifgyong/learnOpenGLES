attribute vec4 Position;
attribute vec4 SourceColor;

uniform float valueChange;
uniform vec4 SourceColor2;


uniform mat4 maritx;

varying lowp vec4 fColor;

void main(){
    
    fColor = SourceColor;
//    float x = sin(valueChange);
    
//    gl_Position = vec4(-x + Position.x, Position.y - x,0, 1);
    gl_Position =   Position * maritx ;
}
