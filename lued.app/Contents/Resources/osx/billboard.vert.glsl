#version 330
uniform vec3 billboardCenterWorld;
uniform vec3 camRightWorld;
in vec3 pos;
uniform vec3 billboardSize;
uniform vec3 camUpWorld;
uniform mat4 P;
uniform mat4 V;
uniform mat4 M;
out vec2 texCoord;
in vec2 tex;
out vec4 color;
in vec4 col;
in vec3 nor;
out vec3 normal;


void main()
{
	vec3 vertexPosWorld;
	vertexPosWorld = ((billboardCenterWorld + ((camRightWorld * pos[0]) * billboardSize[0])) + ((camUpWorld * pos[1]) * billboardSize[1]));
	gl_Position = (((P * V) * M) * vec4(vertexPosWorld[0], vertexPosWorld[1], vertexPosWorld[2], 1.0));
	texCoord = tex;
	color = col;
	// Branch to 6
	// Label 6
	return;
}

