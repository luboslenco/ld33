#version 330
uniform mat4 mvpMatrix;
in vec3 vertexPosition;
out vec3 norm;
in vec3 normalPosition;
out vec2 texCoord;
in vec2 texPosition;


void main()
{
	gl_Position = (mvpMatrix * vec4(vertexPosition[0], vertexPosition[1], vertexPosition[2], 1.0));
	norm = normalPosition;
	texCoord = texPosition;
	// Branch to 6
	// Label 6
	return;
}

