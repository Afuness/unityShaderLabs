Shader "unityShaderLabs/SimpleShaders/06_AlphaMixTexture"{
    Properties{
        _MainTex("Main Texture",2D) = "white"{}
        _AlphaTex("Alpha Texture",2D) = "white"{}
    }

    SubShader{
        Pass{
            /*
            Previous 是上一次SetTexture的结果
            Primary 是来自光照计算的颜色或是当它绑定时的顶点颜色
            Texture是在SetTexture中被定义的纹理的颜色
            Constant是被ConstantColor定义的颜色
            */
            SetTexture[_MainTex]{Combine texture}

            //combine src1 * src2
            //将源1和源2的元素相乘。结果会比单独输出任何一个都要暗

            //这里的previous是前面设置的_MainTex的纹理
            SetTexture[_AlphaTex]{Combine texture * previous}
        }
    }
}