#version 330
// Unknown execution mode
out vec4 krafix_FragColor;
in vec4 matcolor;
in vec3 position;
in vec3 normal;


void main()
{
	krafix_FragColor = vec4(vec3(matcolor[0], matcolor[1], matcolor[2])[0], vec3(matcolor[0], matcolor[1], matcolor[2])[1], vec3(matcolor[0], matcolor[1], matcolor[2])[2], 1.0);
	// Branch to 6
	// Label 6
	return;
}

