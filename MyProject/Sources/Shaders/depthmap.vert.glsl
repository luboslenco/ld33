#ifdef GL_ES
precision highp float;
#endif

attribute vec3 pos;
attribute vec2 tex;
attribute vec3 nor;
attribute vec4 col;

uniform mat4 dMVP;

varying vec4 position;
varying float depth;

void kore() {

	gl_Position = dMVP * vec4(pos, 1.0);
	position = gl_Position;
	depth = gl_Position.z / 20.0;
}
