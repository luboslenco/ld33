#version 330
// Unknown execution mode
out vec4 krafix_FragColor;
uniform bool texturing;
uniform sampler2D stex;
in vec2 texCoord;
in vec4 color;


void main()
{
	// Merge 12 0
	if (texturing) // true: 11 false: 27
	{ // Label 11
		krafix_FragColor = texture(stex, texCoord);
		// Branch to 12
	}
	else
	{ // Label 27
		krafix_FragColor = vec4(vec3(color[0], color[1], color[2])[0], vec3(color[0], color[1], color[2])[1], vec3(color[0], color[1], color[2])[2], 1.0);
		// Branch to 12
	} // Label 12
	// Branch to 6
	// Label 6
	return;
}

