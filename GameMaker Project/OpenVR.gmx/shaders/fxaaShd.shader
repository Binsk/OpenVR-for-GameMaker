attribute vec3 in_Position;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vTexcoord = in_TextureCoord;
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~uniform float u_iStrength;
uniform vec2  u_vTexelSize;

varying vec2  v_vTexcoord;
varying vec4  v_vColor;

void main()
{
    gl_FragColor = texture2D(gm_BaseTexture, v_vTexcoord);

    float fReduceMul = 1.0 / 8.0, // Edge-detection threshold. 1/16 a bit much, 1/4 a bit low
          fReduceMin = 1.0 / 128.0;
          
    vec3  vNW = texture2D(gm_BaseTexture, v_vTexcoord + (vec2(-u_vTexelSize.x, -u_vTexelSize.y))).xyz,
          vNE = texture2D(gm_BaseTexture, v_vTexcoord + (vec2(u_vTexelSize.x, -u_vTexelSize.y))).xyz,
          vSW = texture2D(gm_BaseTexture, v_vTexcoord + (vec2(-u_vTexelSize.x, u_vTexelSize.y))).xyz,
          vSE = texture2D(gm_BaseTexture, v_vTexcoord + (vec2(u_vTexelSize.x, u_vTexelSize.y))).xyz,
          vM  = texture2D(gm_BaseTexture, v_vTexcoord).xyz;
          
    vec3 vLuma = vec3(0.299, 0.587, 0.114);
    float fLumaNW = dot(vNW, vLuma),
          fLumaNE = dot(vNE, vLuma),
          fLumaSW = dot(vSW, vLuma),
          fLumaSE = dot(vSE, vLuma),
          fLumaM  = dot(vM,  vLuma);
          
    float fLumaMin = min(fLumaM, min(min(fLumaNW, fLumaNE), min(fLumaSW, fLumaSE))),
          fLumaMax = max(fLumaM, max(max(fLumaNW, fLumaNE), max(fLumaSW, fLumaSE)));
          
    vec2 vDirection = vec2(-((fLumaNW + fLumaNE) - (fLumaSW + fLumaSE)),
                           ((fLumaNW + fLumaSW)) - (fLumaNE + fLumaSE));
                           
    float fDirectionReduced = max((fLumaNW + fLumaNE + fLumaSW + fLumaSE) * (0.25 * fReduceMul),
                                  fReduceMin);
                                  
    float fRDM = 1.0 / (min(abs(vDirection.x), abs(vDirection.y)) + fDirectionReduced);
    
    vDirection = min(vec2(u_iStrength, u_iStrength),
                     max(vec2(-u_iStrength, -u_iStrength),
                         vDirection * fRDM)) * u_vTexelSize;
                         
    vec3 vRGBOne = 0.5 * (
                    texture2D(gm_BaseTexture, v_vTexcoord + vDirection * (1.0 / 3.0 - 0.5)).xyz +
                    texture2D(gm_BaseTexture, v_vTexcoord + vDirection * (2.0 / 3.0 - 0.5)).xyz);
    vec3 vRGBTwo = vRGBOne * 0.5 + 0.25 * (
                    texture2D(gm_BaseTexture, v_vTexcoord + vDirection * -0.5).xyz + 
                    texture2D(gm_BaseTexture, v_vTexcoord + vDirection * 0.5).xyz);
    float fLuma = dot(vRGBTwo, vLuma);
    
    if ((fLuma < fLumaMin) || (fLuma > fLumaMax))
        gl_FragColor.rgb = vRGBOne;
    else
        gl_FragColor.rgb = vRGBTwo;
        
    gl_FragColor.a = texture2D(gm_BaseTexture, v_vTexcoord).a;
}

