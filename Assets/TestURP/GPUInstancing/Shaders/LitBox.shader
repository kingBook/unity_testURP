Shader "TestURP/LitBox" {
    Properties {
        [MainTexture] _BaseMap("Albedo", 2D) = "white" {}
        [MainColor] _BaseColor("Color", Color) = (1,1,1,1)
        _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5
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
                float3 normalOS : NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                half4 color : COLOR;
                float2 uv : TEXCOORD0;
                float3 normalWS : TEXCOORD1;
                float4 positionWS : TEXCOORD2;
            };

            float _Cutoff;
            half4 _BaseColor;

            TEXTURE2D_X(_BaseMap);
            SAMPLER(sampler_BaseMap);

            StructuredBuffer<float4x4> transformBuffer;
            StructuredBuffer<half4> colorBuffer;


            Varyings vert(const Attributes input)
            {
                float4 positionOS = input.positionOS;
                uint instanceID = input.instanceID;
                float2 uv = input.uv;
                float3 normalOS = input.normalOS;

                // transform
                float4x4 m = transformBuffer[instanceID];
                float4 positionWS = mul(m, positionOS);
                positionWS /= positionWS.w;
                normalOS = mul(m, float4(normalOS, 0)).xyz;

                Varyings output;
                output.positionWS = positionWS;
                output.positionHCS = mul(UNITY_MATRIX_VP, positionWS);
                output.normalWS = mul(unity_ObjectToWorld, float4(normalOS, 0.0)).xyz;
                output.color = colorBuffer[instanceID];
                output.uv = uv;
                return output;
            }

            half4 frag(const Varyings input): SV_Target
            {
                half4 diffuseColor = SAMPLE_TEXTURE2D_X(_BaseMap, sampler_BaseMap, input.uv);
                if (diffuseColor.a < _Cutoff)
                {
                    discard;
                    return 0;
                }

                //计算光照和阴影，光照采用Lembert Diffuse.
                float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS.xyz);
                Light mainLight = GetMainLight(shadowCoord);
                float3 lightDir = mainLight.direction;
                float3 lightColor = mainLight.color;
                float3 normalWS = input.normalWS;
                float4 color = float4(1, 1, 1, 1);
                float minDotLN = 0.2;
                color.rgb = max(minDotLN, abs(dot(lightDir, normalWS))) * lightColor * diffuseColor.rgb * input.color.
                    rgb
                    * mainLight.shadowAttenuation;
                return color;
            }
            ENDHLSL
        }
    }
    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}