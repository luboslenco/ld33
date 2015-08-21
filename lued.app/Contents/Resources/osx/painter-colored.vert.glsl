#version 330
uniform mat4 projectionMatrix;
in vec3 vertexPosition;
out vec4 fragmentColor;
in vec4 vertexColor;


void main()
{
	gl_Position = (projectionMatrix * vec4(vertexPosition[0], vertexPosition[1], vertexPosition[2], 1.0));
	fragmentColor = vertexColor;
	// Branch to 6
	// Label 6
	return;
}

