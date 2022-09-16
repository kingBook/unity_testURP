Shader "TestURP/BoxMatrix" {
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

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
            };

            half4 _BaseColor;
            float4x4 _LocalToWorldMatrix;

            Varyings vert(Attributes input)
            {

                float3 positionOS = input.positionOS.xyz;
                float4 positionWS = mul(_LocalToWorldMatrix, float4(positionOS, 1));

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