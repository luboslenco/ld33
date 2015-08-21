#version 330
// Unknown execution mode
out vec4 krafix_FragColor;
uniform sampler2D shadowMap;
uniform bool receiveShadow;
in vec4 lPos;
uniform bool lighting;
in vec3 normal;
uniform vec3 light;
in vec3 position;
uniform vec3 eye;
uniform float roughness;
in vec4 matcolor;
uniform vec3 surface_color;
uniform bool texturing;
uniform sampler2D stex;
in vec2 texCoord;


float shadowSimple(vec4 lPos);

vec2 LightingFuncGGX_FV(float dotLH, float roughness);

float LightingFuncGGX_D(float dotNH, float roughness);

float LightingFuncGGX_OPT3(vec3 N, vec3 V, vec3 L, float roughness, float F0);

void main()
{
	float visibility;
	float specular;
	vec3 n;
	vec3 l;
	vec3 v;
	float dotNL;
	float spec;
	vec3 t;
	vec3 rgb;
	vec4 outcolor;
	visibility = 1.0;
	// Merge 213 0
	if ((receiveShadow && (lPos[3] > 0.0))) // true: 212 false: 213
	{ // Label 212
		visibility = 1.0;
		// Branch to 213
	} // Label 213
	// Merge 217 0
	if (lighting) // true: 216 false: 294
	{ // Label 216
		specular = 0.1;
		n = normalize(normal);
		l = (light - position);
		l = normalize(l);
		v = (eye - position);
		v = normalize(v);
		dotNL = clamp(dot(n, l), 0.0, 1.0);
		spec = LightingFuncGGX_OPT3(n, v, l, roughness, specular);
		// Merge 263 0
		if (spec < 0.0) // true: 262 false: 263
		{ // Label 262
			spec = 0.0;
			// Branch to 263
		} // Label 263
		t = pow(vec3(matcolor[0], matcolor[1], matcolor[2]), vec3(2.2, 2.2, 2.2));
		rgb = (((surface_color * 0.2) + vec3(spec, spec, spec)) + (t * dotNL));
		outcolor = vec4(pow((rgb * visibility), vec3(0.454545, 0.454545, 0.454545))[0], pow((rgb * visibility), vec3(0.454545, 0.454545, 0.454545))[1], pow((rgb * visibility), vec3(0.454545, 0.454545, 0.454545))[2], 1.0);
		// Branch to 217
	}
	else
	{ // Label 294
		outcolor = matcolor;
		// Branch to 217
	} // Label 217
	// Merge 299 0
	if (texturing) // true: 298 false: 317
	{ // Label 298
		krafix_FragColor = vec4(((texture(stex, texCoord) * outcolor) * visibility)[0], ((texture(stex, texCoord) * outcolor) * visibility)[1], ((texture(stex, texCoord) * outcolor) * visibility)[2], ((texture(stex, texCoord) * outcolor) * visibility)[3]);
		// Branch to 299
	}
	else
	{ // Label 317
		krafix_FragColor = vec4((vec3(outcolor[0], outcolor[1], outcolor[2]) * visibility)[0], (vec3(outcolor[0], outcolor[1], outcolor[2]) * visibility)[1], (vec3(outcolor[0], outcolor[1], outcolor[2]) * visibility)[2], 1.0);
		// Branch to 299
	} // Label 299
	// Branch to 6
	// Label 6
	return;
}

float shadowSimple(vec4 lPos)
{
	vec4 lPosH;
	vec4 packedZValue;
	float distanceFromLight;
	float bias;
	lPosH = (lPos / vec4(lPos[3], lPos[3], lPos[3], lPos[3]));
	lPosH[0] = ((lPosH[0] / 2.0) + 0.5);
	lPosH[1] = (1.0 - ((lPosH[1] / -2.0) + 0.5));
	packedZValue = texture(shadowMap, vec2(lPosH[0], lPosH[1]));
	distanceFromLight = packedZValue[0];
	bias = -0.005;
	return ((distanceFromLight > (lPosH[2] - bias)) ? 1.0 : 0.0);
}

vec2 LightingFuncGGX_FV(float dotLH, float roughness)
{
	float alpha;
	float dotLH5;
	float F_a;
	float F_b;
	float k;
	float k2;
	float invK2;
	float vis;
	alpha = (roughness * roughness);
	dotLH5 = pow((1.0 - dotLH), 5.0);
	F_a = 1.0;
	F_b = dotLH5;
	k = (alpha / 2.0);
	k2 = (k * k);
	invK2 = (1.0 - k2);
	vis = inversesqrt((((dotLH * dotLH) * invK2) + k2));
	return vec2((F_a * vis), (F_b * vis));
}

float LightingFuncGGX_D(float dotNH, float roughness)
{
	float alpha;
	float alphaSqr;
	float pi;
	float denom;
	float D;
	alpha = (roughness * roughness);
	alphaSqr = (alpha * alpha);
	pi = 3.14159;
	denom = (((dotNH * dotNH) * (alphaSqr - 1.0)) + 1.0);
	D = (alphaSqr / ((pi * denom) * denom));
	return D;
}

float LightingFuncGGX_OPT3(vec3 N, vec3 V, vec3 L, float roughness, float F0)
{
	vec3 H;
	float dotNL;
	float dotLH;
	float dotNH;
	float D;
	vec2 FV_helper;
	float FV;
	float specular;
	H = normalize((V + L));
	dotNL = clamp(dot(N, L), 0.0, 1.0);
	dotLH = clamp(dot(L, H), 0.0, 1.0);
	dotNH = clamp(dot(N, H), 0.0, 1.0);
	D = LightingFuncGGX_D(dotNH, roughness);
	FV_helper = LightingFuncGGX_FV(dotLH, roughness);
	FV = ((F0 * FV_helper[0]) + ((1.0 - F0) * FV_helper[1]));
	specular = ((dotNL * D) * FV);
	return specular;
}

