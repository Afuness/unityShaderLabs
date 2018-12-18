Shader "unityShaderLabs/SimpleShaders/05_GlowEdge"
{
    Properties{
        _MainColor("Main Color",Color) = (1,1,1,1)
        _TextureDiffuse("Diffuse",2D) = "white"{}
        _EdgeColor("Edge Color",Color) = (1,1,1,1)
        _EdgeStrength("Edge Strength",Range(0,50)) = 0.1
        _EdgeIntensity("Edge Intensity",Range(0,100))= 3
    }

    SubShader{
        Tags{"RenderType" = "Opaque"}

        Pass{
            Name "FirstRender"
            Tags{"LightMode" = "FirstRender"}
            CGPROGRAM
                #pragma vertex vert
				#pragma fragment frag

                #include "UnityCG.cginc"
				#include "AutoLight.cginc"

                
        }
    }

}