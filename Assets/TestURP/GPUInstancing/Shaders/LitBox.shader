Shader "TestURP/LitBox" {
    Properties {
        [MainTexture] _BaseMap("Albedo", 2D) = "white" {}
        [MainColor] _BaseColor("Color", Color) = (1,1,1,1)
    }
    SubShader {
        Tags {
            "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "IgnoreProjector" = "True"
        }
        LOD 300

        Pass {
            Name "ForwardLit"
            Tags {
                "LightMode" = "UniversalForward"
            }

            ZWrite On
            ZTest On
            Cull Off

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            // Material Keywords
            #pragma shader_feature _RECEIVE_SHADOWS_OFF

            // Universal Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE

            // GPU Instancing
            #pragma multi_compile_instancing

            struct Attributes
            {
                float4 positionOS : POSITION;
                uint instanceID : SV_InstanceID;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                half4 color : COLOR;
                float2 uv : TEXCOORD0;
            };


            TEXTURE2D_X(_BaseMap);
            SAMPLER(sampler_BaseMap);

            StructuredBuffer<float4x4> transformBuffer;
            StructuredBuffer<half4> colorBuffer;


            Varyings vert(Attributes input)
            {
                float4 positionOS = input.positionOS;
                uint instanceID = input.instanceID;

                // transform
                float4x4 m = transformBuffer[instanceID];
                positionOS = mul(m, positionOS);

                Varyings output;
                output.positionHCS = mul(UNITY_MATRIX_VP, positionOS);
                output.color = colorBuffer[instanceID];
                return output;
            }

            half4 frag(Varyings input): SV_Target
            {
                half4 diffuseColor = SAMPLE_TEXTURE2D_X(_BaseMap, sampler_BaseMap, input.uv);

                //计算光照和阴影，光照采用Lembert Diffuse.
                float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
                Light mainLight = GetMainLight(shadowCoord);
                float3 lightDir = mainLight.direction;
                float3 lightColor = mainLight.color;
                float3 normalWS = input.normalWS;
                float4 color = float4(1, 1, 1, 1);
                float minDotLN = 0.2;
                color.rgb = max(minDotLN, abs(dot(lightDir, normalWS))) * lightColor * diffuseColor.rgb * _BaseColor.rgb
                    * mainLight.shadowAttenuation;
                return color;
            }
            ENDHLSL
        }
    }
    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}