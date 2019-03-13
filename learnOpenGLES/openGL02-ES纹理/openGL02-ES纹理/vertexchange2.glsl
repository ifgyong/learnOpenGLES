attribute vec4 Position;
attribute vec4 SourceColor;
varying lowp vec4 fColor;

void main(){
    fColor = SourceColor;
    gl_Position = Position;
}
