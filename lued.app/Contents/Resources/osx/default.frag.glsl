#version 330
// Unknown execution mode
out vec4 krafix_FragColor;
uniform sampler2D tex;
in vec2 texCoord;
in vec3 norm;


void main()
{
	krafix_FragColor = texture(tex, texCoord);
	// Merge 27 0
	if ((krafix_FragColor[3] <= 0.5)) // true: 26 false: 27
	{ // Label 26
		discard;
	} // Label 27
	// Branch to 6
	// Label 6
	return;
}

