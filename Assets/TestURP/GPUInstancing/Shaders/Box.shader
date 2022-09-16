Shader "TestURP/Box" {
    Properties {
        _BaseColor("Base Color", Color)=(1, 1, 1, 1)
    }
    SubShader {
        Tags {
            "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline"
        }

        Pass {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // GPU Instancing
            #pragma multi_compile_instancing

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                uint instanceID : SV_InstanceID;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
            };

            half4 _BaseColor;
            float4x4 _LocalToWorldMatrix;
            float4 _OutPos;

            #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
            StructuredBuffer<float4> positionBuffer;
            #endif

            Varyings vert(Attributes input)
            {
                /*float3 positionOS = input.positionOS.xyz;

                #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
                    float4 posBuff = positionBuffer[input.instanceID];
                    positionOS = mul(grassInfo.localToTerrian,float4(positionOS,1)).xyz;
                #endif

                float4 positionWS = mul(_LocalToWorldMatrix, float4(positionOS, 1));
                positionWS /= positionWS.w;

                Varyings output;
                output.positionHCS = mul(UNITY_MATRIX_VP, positionWS);
                return output;*/

                /*Varyings output;
                output.positionHCS = TransformObjectToHClip(input.positionOS.xyz);
                return output;*/

                float3 positionOS = input.positionOS.xyz;
                float4 positionWS = mul(_LocalToWorldMatrix, float4(positionOS, 1));
                positionWS /= positionWS.w;

                Varyings output;
                output.positionHCS = mul(UNITY_MATRIX_VP, positionWS);
                return output;
            }

            half4 frag(): SV_Target
            {
                return _BaseColor;
            }
            ENDHLSL
        }
    }
}