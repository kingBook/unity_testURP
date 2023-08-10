Shader "LearnShaders/Lit1" {
    Properties {
        [MainTexture] _BaseMap("Albedo", 2D) = "white" {}
        [MainColor] _BaseColor("Color", Color) = (1,1,1,1)

    }

    SubShader {
        Tags {
            "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline"
        }
        LOD 100

        Pass {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            // 灯光程序库
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
                float4 normalOS : NORMAL;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 positionWS : TEXCOORD1;
                float3 normalWS : NORMAL;
            };

            // 此宏将 _BaseMap 声明为 Texture2D 对象
            TEXTURE2D(_BaseMap);
            // 此宏为 _BaseMap 纹理声明采样器
            SAMPLER(sampler_BaseMap);

            // 要使 Unity shader 兼容 SRP Batcher，请在名为 UnityPerMaterial 的 CBUFFER 块中声明与材质相关的所有属性。
            CBUFFER_START(UnityPerMaterial)
            half4 _BaseColor;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;

                // 输入物体空间顶点数据
                VertexPositionInputs position_inputs = GetVertexPositionInputs(input.positionOS.xyz);
                // 获取裁切空间顶点
                output.positionCS = position_inputs.positionCS;
                // 获取世界空间顶点
                output.positionWS = position_inputs.positionWS;

                // 输入物体空间法线数据
                VertexNormalInputs vertex_normal_inputs = GetVertexNormalInputs(input.normalOS.xyz);
                // 获取世界空间法线
                output.normalWS = vertex_normal_inputs.normalWS;

                // 传递法线变量
                output.uv = input.uv;

                return output;
            }

            half4 frag(Varyings input): SV_Target
            {
                half4 output = _BaseColor;
                // 获取纹理
                float4 baseTex = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.uv);

                // 物体世界坐标放入阴影计算
                float4 SHADOW_COORDS = TransformWorldToShadowCoord(input.positionWS);
                // 输出灯光数据
                Light lightData = GetMainLight(SHADOW_COORDS);
                // 光照渐变
                float Ramp_light = dot(lightData.direction, input.normalWS) * 0.5 + 0.5;
                // 颜色叠加光照
                output.rgb *= Ramp_light * lightData.color;
                //
                output *= baseTex;
                
                // clip(x), 如果给定参数的任何一个分量是负数，就会舍弃当前像素的输出颜色
                clip(output.a - 0.5);
                
                return output;
            }
            ENDHLSL
        }
    }
}