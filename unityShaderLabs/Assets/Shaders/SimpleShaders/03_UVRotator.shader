// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
// Rotate UV


Shader "unityShaderLabs/SimpleShaders/03_UVRotator"
{
    Properties{
        _Color ("Main Color",Color) = (1,1,1,1)
        _MainTex("Main Texture",2D) = "white" {}
        _RSpeed("Rotate Speed",Range(1,100)) = 10
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
            float _RSpeed;

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
                float2 uv = i.uv.xy - float2(0.5,0.5); //将旋转点位移到中心
                //(x,y)乘于旋转矩阵(cosφ,sinφ;-sinφ,cosφ)，得到旋转结果
                float2 rotate = float2(cos(_RSpeed * _Time.x),sin(_RSpeed * _Time.x));
                uv = float2(uv.x * rotate.x - uv.y * rotate.y,uv.x * rotate.y + uv.y * rotate.x);
                uv += float2(0.5,0.5);
                half4 c = tex2D(_MainTex,uv.xy) * _Color;
                return c;
            }

            ENDCG
        }
    }
}