attribute vec4 p;
uniform float change;
uniform float changeColor;
void main(void){
    float x = p.y * sin(change);
    float y = p.x * cos(change);
    gl_Position = vec4(x, y, 0, 1.0);
}
