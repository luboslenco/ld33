#version 330
uniform vec3 billboardCenterWorld;
uniform vec3 camRightWorld;
in vec3 vertexPosition;
uniform vec3 billboardSize;
uniform vec3 camUpWorld;
uniform mat4 mvpMatrix;
out vec4 color;
in vec4 vertexColor;
out vec2 texCoord;
in vec2 texPosition;
in vec3 normalPosition;


void main()
{
	vec3 vertexPosWorld;
	vertexPosWorld = ((billboardCenterWorld + ((camRightWorld * vertexPosition[0]) * billboardSize[0])) + ((camUpWorld * vertexPosition[1]) * billboardSize[1]));
	gl_Position = (mvpMatrix * vec4(vertexPosWorld[0], vertexPosWorld[1], vertexPosWorld[2], 1.0));
	color = vertexColor;
	texCoord = texPosition;
	// Branch to 6
	// Label 6
	return;
}

