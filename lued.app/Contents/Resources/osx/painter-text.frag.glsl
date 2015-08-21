#version 330
// Unknown execution mode
out vec4 krafix_FragColor;
in vec4 fragmentColor;
uniform sampler2D tex;
in vec2 texCoord;


void main()
{
	krafix_FragColor = vec4(vec3(fragmentColor[0], fragmentColor[1], fragmentColor[2])[0], vec3(fragmentColor[0], fragmentColor[1], fragmentColor[2])[1], vec3(fragmentColor[0], fragmentColor[1], fragmentColor[2])[2], (texture(tex, texCoord)[0] * fragmentColor[3]));
	// Branch to 6
	// Label 6
	return;
}

