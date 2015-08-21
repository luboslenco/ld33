#version 330
uniform mat4 M;
in vec3 pos;
uniform mat4 P;
uniform mat4 V;
out vec3 position;
out vec3 normal;
in vec3 nor;
out vec4 matcolor;
uniform vec4 diffuse_color;


void main()
{
	vec4 mpos;
	mpos = (M * vec4(pos[0], pos[1], pos[2], 1.0));
	gl_Position = ((P * V) * mpos);
	position = (vec3(mpos[0], mpos[1], mpos[2]) / vec3(mpos[3], mpos[3], mpos[3]));
	normal = normalize(vec3((M * vec4(nor[0], nor[1], nor[2], 0.0))[0], (M * vec4(nor[0], nor[1], nor[2], 0.0))[1], (M * vec4(nor[0], nor[1], nor[2], 0.0))[2]));
	matcolor = diffuse_color;
	// Branch to 6
	// Label 6
	return;
}

