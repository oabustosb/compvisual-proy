#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform float zoomlod;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  gl_FragColor = textureLod(texture, vertTexCoord.st, zoomlod);
}