#version 330
uniform sampler2D skinning;
in vec3 vertexPosition;
in vec3 normalPosition;
in vec4 bone;
out vec3 norm;
uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;
out vec4 color;
in vec4 vertexColor;
out vec2 texCoord;
in vec2 texPosition;
in vec4 weight;
uniform mat4 mvpMatrix;
uniform mat4 dbmvpMatrix;
uniform bool lighting;
uniform bool rim;
out vec4 shadowCoord;
out vec4 viewSpacePos;


float packColor(vec4 color);

vec4 skinningRead(float id);

mat4 skinWorldMatrix(vec4 bone);

void main()
{
	vec4 lv;
	vec3 ln;
	mat4 wm;
	vec4 lightDir;
	vec4 ambient;
	vec4 diffuse;
	lv = vec4(vertexPosition[0], vertexPosition[1], vertexPosition[2], 1.0);
	ln = vec3(normalPosition[0], normalPosition[1], normalPosition[2]);
	wm = skinWorldMatrix(bone);
	norm = (ln * mat3(vec3(wm[0][0], wm[0][1], wm[0][2]), vec3(wm[1][0], wm[1][1], wm[1][2]), vec3(wm[2][0], wm[2][1], wm[2][2])));
	gl_Position = (((projectionMatrix * viewMatrix) * wm) * lv);
	color = vertexColor;
	lightDir = vec4(0.3, 0.3, 0.3, 1.0);
	ambient = vec4(0.2, 0.2, 0.2, 1.0);
	ambient = (ambient * color);
	diffuse = color;
	color = (ambient + (diffuse * dot(lightDir, vec4(normalPosition[0], normalPosition[1], normalPosition[2], 1.0))));
	texCoord = texPosition;
	// Branch to 6
	// Label 6
	return;
}

float packColor(vec4 color)
{
	return ((color[0] + (color[1] * 256.0)) + ((color[2] * 256.0) * 256.0));
}

vec4 skinningRead(float id)
{
	float r;
	float g;
	float b;
	float a;
	vec4 res;
	r = packColor(texture(skinning, vec2(0.0, (((id * 4.0) + 0.0) / 8191.0))));
	g = packColor(texture(skinning, vec2(0.0, (((id * 4.0) + 1.0) / 8191.0))));
	b = packColor(texture(skinning, vec2(0.0, (((id * 4.0) + 2.0) / 8191.0))));
	a = packColor(texture(skinning, vec2(0.0, (((id * 4.0) + 3.0) / 8191.0))));
	res = vec4(r, g, b, a);
	return res;
}

mat4 skinWorldMatrix(vec4 bone)
{
	float o;
	float b;
	vec4 l0;
	vec4 l1;
	vec4 l2;
	mat4 j0;
	mat4 b0;
	mat4 j1;
	mat4 b1;
	mat4 j2;
	mat4 b2;
	mat4 j3;
	mat4 b3;
	o = 1024.0;
	b = (bone[0] * 3.0);
	l0 = skinningRead(b);
	l1 = skinningRead((b + 1.0));
	l2 = skinningRead((b + 2.0));
	j0 = mat4(vec4(l0[0], l0[1], l0[2], l0[3]), vec4(l1[0], l1[1], l1[2], l1[3]), vec4(l2[0], l2[1], l2[2], l2[3]), vec4(0.0, 0.0, 0.0, 1.0));
	l0 = skinningRead((b + o));
	l1 = skinningRead(((b + 1.0) + o));
	l2 = skinningRead(((b + 2.0) + o));
	b0 = mat4(vec4(l0[0], l0[1], l0[2], l0[3]), vec4(l1[0], l1[1], l1[2], l1[3]), vec4(l2[0], l2[1], l2[2], l2[3]), vec4(0.0, 0.0, 0.0, 1.0));
	b = (bone[1] * 3.0);
	l0 = skinningRead(b);
	l1 = skinningRead((b + 1.0));
	l2 = skinningRead((b + 2.0));
	j1 = mat4(vec4(l0[0], l0[1], l0[2], l0[3]), vec4(l1[0], l1[1], l1[2], l1[3]), vec4(l2[0], l2[1], l2[2], l2[3]), vec4(0.0, 0.0, 0.0, 1.0));
	l0 = skinningRead((b + o));
	l1 = skinningRead(((b + 1.0) + o));
	l2 = skinningRead(((b + 2.0) + o));
	b1 = mat4(vec4(l0[0], l0[1], l0[2], l0[3]), vec4(l1[0], l1[1], l1[2], l1[3]), vec4(l2[0], l2[1], l2[2], l2[3]), vec4(0.0, 0.0, 0.0, 1.0));
	b = (bone[2] * 3.0);
	l0 = skinningRead(b);
	l1 = skinningRead((b + 1.0));
	l2 = skinningRead((b + 2.0));
	j2 = mat4(vec4(l0[0], l0[1], l0[2], l0[3]), vec4(l1[0], l1[1], l1[2], l1[3]), vec4(l2[0], l2[1], l2[2], l2[3]), vec4(0.0, 0.0, 0.0, 1.0));
	l0 = skinningRead((b + o));
	l1 = skinningRead(((b + 1.0) + o));
	l2 = skinningRead(((b + 2.0) + o));
	b2 = mat4(vec4(l0[0], l0[1], l0[2], l0[3]), vec4(l1[0], l1[1], l1[2], l1[3]), vec4(l2[0], l2[1], l2[2], l2[3]), vec4(0.0, 0.0, 0.0, 1.0));
	b = (bone[3] * 3.0);
	l0 = skinningRead(b);
	l1 = skinningRead((b + 1.0));
	l2 = skinningRead((b + 2.0));
	j3 = mat4(vec4(l0[0], l0[1], l0[2], l0[3]), vec4(l1[0], l1[1], l1[2], l1[3]), vec4(l2[0], l2[1], l2[2], l2[3]), vec4(0.0, 0.0, 0.0, 1.0));
	l0 = skinningRead((b + o));
	l1 = skinningRead(((b + 1.0) + o));
	l2 = skinningRead(((b + 2.0) + o));
	b3 = mat4(vec4(l0[0], l0[1], l0[2], l0[3]), vec4(l1[0], l1[1], l1[2], l1[3]), vec4(l2[0], l2[1], l2[2], l2[3]), vec4(0.0, 0.0, 0.0, 1.0));
	return mat4(vec4(1.0, 0.0, 0.0, 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0), vec4(0.0, 0.0, 0.0, 1.0));
}

