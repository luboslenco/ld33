#ifdef GL_ES
precision mediump float;
#endif

varying vec4 position;
varying float depth;

void kore() {

    //float normalizedDistance = position.z / position.w;
    //float normalizedDistance = gl_FragCoord.z;
    //normalizedDistance += 0.005;
 
 //    float ndcDepth = ndcPos.z =
	//     (2.0 * gl_FragCoord.z - gl_DepthRange.near - gl_DepthRange.far) /
	//     (gl_DepthRange.far - gl_DepthRange.near);
	// float clipDepth = ndcDepth / gl_FragCoord.w;
	// gl_FragColor = vec4((clipDepth * 0.5) + 0.5); 
 
    //gl_FragColor = vec4(normalizedDistance, normalizedDistance, normalizedDistance, 1.0);
    gl_FragColor = vec4(1.0-depth, 1.0-depth, 1.0-depth, 1.0);
}
