#version 330
// Unknown execution mode
out vec4 krafix_FragColor;
uniform sampler2D tex;
in vec2 texCoord;
in vec4 color;


void main()
{
	vec4 texcolor;
	texcolor = (texture(tex, texCoord) * color);
	texcolor = vec4((vec3(texcolor[0], texcolor[1], texcolor[2]) * color[3])[0], (vec3(texcolor[0], texcolor[1], texcolor[2]) * color[3])[1], (vec3(texcolor[0], texcolor[1], texcolor[2]) * color[3])[2], texcolor[3]);
	krafix_FragColor = texcolor;
	// Branch to 6
	// Label 6
	return;
}

