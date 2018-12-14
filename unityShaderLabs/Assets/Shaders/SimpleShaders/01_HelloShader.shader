// Shader存放目录
Shader "unityShaderLabs/SimpleShaders/01_HelloShader"
{
    // 属性：向外暴露的接口，可以在Inspector面板获取响应属性接口
    Properties
    {
        // 属性的结构：
        //      Shader变量名 ("对应的属性名称",属性类型) = 默认值 {option}
        //      比如
        //      _MainTex是Shader内部使用的变量名称
        //      Texture是Inspector面板的接口名称
        //      2D表示这是2D纹理属性
        //      MainTex默认值一般设为white，这样可以防止它与其他贴图产生混色
        _MainTex ("Texture", 2D) = "white" {}
        
        // 多种属性类型(不区分大小写)
        _RangeValue ("RangeValue",Range(0,1)) = 0.5
        _Color ("MainColor",Color) = (1,1,1,1)
        _CubeMap ("Cube Map",Cube) = "" {}
        _FloatType ("Float type",float) = 100
        _VectorType ("Vector type",vector) = (0,0,0,0)

    }

    // 可定义多个subshader，对于不同的显卡，选择不同的subshader，subshaders只会执行其中一个
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
