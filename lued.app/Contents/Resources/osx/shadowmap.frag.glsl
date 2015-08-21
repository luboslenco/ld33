#version 330
// Unknown execution mode
out vec4 krafix_FragColor;
in vec4 position;


void main()
{
	float normalizedDistance;
	normalizedDistance = (position[2] / position[3]);
	krafix_FragColor = vec4(normalizedDistance, normalizedDistance, normalizedDistance, 1.0);
	// Branch to 6
	// Label 6
	return;
}

