#version 330
uniform mat4 dbMVP;
in vec3 vertexPosition;
out vec4 position;
in vec2 texPosition;
in vec3 normalPosition;
in vec4 vertexColor;


void main()
{
	gl_Position = (dbMVP * vec4(vertexPosition[0], vertexPosition[1], vertexPosition[2], 1.0));
	position = gl_Position;
	// Branch to 6
	// Label 6
	return;
}

