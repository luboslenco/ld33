#version 330
uniform mat4 P;
uniform mat4 V;
uniform mat4 M;
in vec3 pos;
out vec4 matcolor;
in vec4 col;


void main()
{
	gl_Position = (((P * V) * M) * vec4(pos[0], pos[1], pos[2], 1.0));
	matcolor = vec4(vec3(col[0], col[1], col[2])[0], vec3(col[0], col[1], col[2])[1], vec3(col[0], col[1], col[2])[2], 1.0);
	// Branch to 6
	// Label 6
	return;
}

