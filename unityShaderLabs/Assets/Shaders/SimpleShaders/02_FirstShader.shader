// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "unityShaderLabs/SimpleShaders/02_FirstShader"
{
    Properties{
        _Color ("Main Color",Color) = (1,1,1,1)
        _MainTex("Main Texture",2D) = "white" {}
    }
    SubShader{
        Tags{
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }
        Blend SrcAlpha OneMinusSrcAlpha
        Pass{

            Cull off   //关闭剔除背面，使模型正反面均显示
            CGPROGRAM
            #pragma vertex vert  
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _Color;

            struct v2f{
                float4 pos:POSITION;
                float4 uv:TEXCOORD0;

            };

            v2f vert(appdata_base v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }

            half4 frag(v2f i):Color{
                half4 c = tex2D(_MainTex,i.uv.xy) * _Color;
                return c;
            }

            ENDCG
        }
    }
}