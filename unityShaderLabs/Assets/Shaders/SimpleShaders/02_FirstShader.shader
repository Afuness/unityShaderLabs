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
                float4 col:COLOR;
            };

            v2f vert(appdata_base v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                //将法线值以颜色渐变的形式表现出来
                o.col.xyz = v.normal * 0.5 + 0.5;
                o.col.w = 1.0;
                return o;
            }

            half4 frag(v2f i):Color{
                half4 c = tex2D(_MainTex,i.uv.xy) * i.col * _Color;
                //half4 c = i.col;
                return c;
            }

            ENDCG
        }
    }
}