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
        //使用标签来告诉渲染引擎渲染对象的方式
        //Tags { "TagName1" ="Value1" "TagName2" = "Value2" }

        //-------- ---------队列标签（Queue tag）--------------

        //后台（Background）     -      这个渲染队列在所有队列之前被渲染，被用于渲染天空盒之类的对象。

        //几何体（Geometry，默认值）-    这个队列被用于大多数对象。 不透明的几何体使用这个队列。

        //透明（Transparent） -         这个渲染队列在几何体队列之后被渲染，采用由后到前的次序。
        //                             任何采用alpha混合的对象（也就是不对深度缓冲产生写操作的着色器）
        //                             应该在这里渲染（如玻璃，粒子效果等）

        //覆盖（Overlay） -             这个渲染队列被用于实现叠加效果。任何需要最后渲染的对象应该放置在此处。
        //                            （如镜头光晕等）

        //Tags { "Queue" ="Geometry+n" } 
        //定义特殊的渲染顺序



        //----------忽略投影标签（IgnoreProjector tag）--------
        //若设置IgnoreProjector（忽略投影）标签为"True"，那么使用这个着色器的对象就不会被投影机制（Projectors）所影响。


        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            //一个通道能定义它的Name 和任意数量的Tags。通过使用tags来告诉渲染引擎在什么时候该如何渲染他们所期望的效果

            //-----专属于Pass内部的tags

            //---------光照模式标签（LightMode tag）----------

            /*
            Always: 总是渲染。没有运用光照。
            ForwardBase:用于正向渲染,环境光、方向光和顶点光等
            ForwardAdd:用于正向渲染，用于设定附加的像素光，每个光照对应一个pass
            PrepassBase:用于延迟光照，渲染法线/镜面光。
            PrepassFinal:用于延迟光照，通过结合纹理，光照和自发光渲染最终颜色
            Vertex: 用于顶点光照渲染，当物体没有光照映射时，应用所有的顶点光照
            VertexLMRGBM:用于顶点光照渲染，当物体有光照映射的时候使用顶点光照渲染。在平台上光照映射是RGBM 编码
            VertexLM:用于顶点光照渲染，当物体有光照映射的时候使用顶点光照渲染。在平台上光照映射是double-LDR 编码（移动平台，及老式台式CPU）
            ShadowCaster: 使物体投射阴影。
            ShadowCollector: 为正向渲染对象的路径，将对象的阴影收集到屏幕空间缓冲区中。
            */


            //---------------条件选项标签 （RequireOptions tag ）-------

            //SoftVegetation: 如果在QualitySettings中开启渲染软植被（Edit->Project Settings->Quality），
            //                则该pass可以渲染

            //渲染设置 （Render Setup ）

            //Material { Material Block }  定义一个使用顶点光照管线的材质
            //Lighting On | Off             开启或关闭顶点光照。开启灯光之后，顶点光照才会有作用
            //Cull Back | Front | Off       设置多边形剔除模式。
            //ZTest (Less | Greater | LEqual | GEqual |Equal | NotEqual | Always)
            //                              设置深度测试模式


            //纹理设置（Texture Setup ）
            //SetTexture [texture property]{ [Combineoptions] }
            //纹理设置，用于配置固定函数多纹理管线，当自定义fragment shaders 被使用时，这个设置也就被忽略掉了。


            //UsePass——包含已经写好的通道
            //UsePass 可以包含来自其他着色器的通道，来减少重复的代码。
            //  UsePass "Specular/BASE"
            //这个命令可以使用内置的高光着色器中的名叫"Base"的通道

            // CG
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
