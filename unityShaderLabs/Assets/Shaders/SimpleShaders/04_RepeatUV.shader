// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
// Rotate UV


Shader "unityShaderLabs/SimpleShaders/04_RepeatUV"
{
    Properties{
        _Color ("Main Color",Color) = (1,1,1,1)
        _MainTex("Main Texture",2D) = "white" {}
        _DetailTex("Detail Texture",2D) = "white" {}
    }
    SubShader{
        Tags{
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }
        Blend SrcAlpha OneMinusSrcAlpha
        Pass{

            CGPROGRAM
            #pragma vertex vert  
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _Color;
            sampler2D _DetailTex;

            struct v2f{
                float4 pos:POSITION;
                float2 uv:TEXCOORD0;
            };

            float4 _MainTex_ST;

            v2f vert(appdata_base v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
                return o;
            }

            half4 frag(v2f i):Color{
                half4 c = tex2D(_MainTex,i.uv) * _Color;
                half4 d = tex2D(_DetailTex,i.uv);
                return c*d;
            }

            ENDCG
        }
    }
}