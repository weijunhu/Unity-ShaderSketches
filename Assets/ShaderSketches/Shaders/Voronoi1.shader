﻿Shader "ShaderSketches/Voronoi1"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"
    
    float2 random2(float2 st)
    {
        st = float2(dot(st, float2(127.1, 311.7)),
                    dot(st, float2(269.5, 183.3)));
        return -1.0 + 2.0 * frac(sin(st) * 43758.5453123);
    }
    
    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        
        float2 st = i.uv;
        st *= 4.0;

        float2 ist = floor(st);
        float2 fst = frac(st);

        float min_distance = 10;
        float2 min_point = 0;

        for (int y = -1; y <= 1; y++)
        for (int x = -1; x <= 1; x++)
        {
            float2 neighbor = float2(x, y);
            float2 p = 0.5 + 0.5 * sin(_Time.x * 20 + 6.2831 * random2(ist + neighbor));

            float distance = length(neighbor + p - fst);
            if (distance < min_distance)
            {
                min_distance = distance;
                min_point = p;
            }
        }
        
        return float4(min_point, 1, 1);
    }
    
    ENDCG

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            ENDCG
        }
    }
}
