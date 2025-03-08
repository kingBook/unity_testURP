Shader "TestURP/Box" {
    Properties {
        //_BaseColor("Base Color", Color)=(1, 1, 1, 1)
    }
    SubShader {
        Tags {
            "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline"
        }

        Pass {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            // GPU Instancing
            #pragma multi_compile_instancing

            struct Attributes
            {
                float4 positionOS : POSITION;
                uint instanceID : SV_InstanceID;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                half4 color : COLOR;
            };

            //half4 _BaseColor;
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
                output.color=colorBuffer[instanceID];
                return output;
            }

            half4 frag(Varyings input): SV_Target
            {
                //return _BaseColor;
                return input.color;
            }
            ENDHLSL
        }
    }
     FallBack "Hidden/Universal Render Pipeline/FallbackError"
}