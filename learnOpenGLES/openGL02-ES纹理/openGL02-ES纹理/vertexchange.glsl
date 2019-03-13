attribute vec4 p;
uniform float change;
attribute vec4 color;

varying vec4 fColor;
void main(void){
    fColor = color;
    gl_Position = p * change;
}
