#version 330
// Unknown execution mode
out vec4 krafix_FragColor;
uniform bool texturing;
uniform sampler2D tex;
in vec2 texCoord;
in vec4 color;
uniform sampler2D shadowMap;
in vec4 shadowCoord;
in vec4 viewSpacePos;


void main()
{
	// Merge 12 0
	if (texturing) // true: 11 false: 27
	{ // Label 11
		krafix_FragColor = texture(tex, texCoord);
		// Branch to 12
	}
	else
	{ // Label 27
		krafix_FragColor = color;
		// Branch to 12
	} // Label 12
	// Branch to 6
	// Label 6
	return;
}

