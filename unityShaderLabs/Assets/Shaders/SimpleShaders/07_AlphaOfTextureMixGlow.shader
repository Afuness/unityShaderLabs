Shader "unityShaderLabs/SimpleShaders/07_Alpha Of Texture Mix Glow"{
    Properties{
        _MainTex("Main Texture  -- Glow",2D) = "white"{}
        _GlowColor("Glow Color",Color) = (1,1,1,1)
    }

    SubShader{
        Pass{
            //Material { Material Block }  定义一个使用顶点光照管线的材质
            //设置白色的顶点光照
            Material{
                Diffuse(1,1,1,1)
                Ambient(1,1,1,1)
            }

            // Open lighting
            Lighting On

            //使用颜色混合纹理
            SetTexture[_MainTex]{
                ConstantColor[_GlowColor]
                Combine constant lerp(texture) previous
            }

            SetTexture[_MainTex]{Combine previous * texture }
        }
    }
}