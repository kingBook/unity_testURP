Shader "Example/StandardLight" {
    Properties {
        _BaseColor("Base Color", Color)=(1, 1, 1, 1) // 内置胶囊体的颜色默认为 0x808080
        _Gloss("Gloss",Range(8,20)) = 8.0
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
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            CBUFFER_START(UnityPerMaterial)

            half4 _BaseColor;
            half _Gloss;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                half3 normal:NORMAL;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                half3 worldNormal:TEXCOORD0;
                float3 worldPos:TEXCOORD1;
            };

            Varyings vert(Attributes input)
            {
                Varyings output;
                // 从对象空间到裁剪空间
                output.positionCS = TransformObjectToHClip(input.positionOS.xyz);
                output.worldNormal = TransformObjectToWorldNormal(input.normal);
                output.worldPos = TransformObjectToWorld(input.positionOS.xyz);
                return output;
            }

            half4 frag(Varyings input): SV_Target
            {
                Light mainLight = GetMainLight();

                half3 diffuse = LightingLambert(mainLight.color, mainLight.direction, input.worldNormal);

                // 计算高光 
                half3 viewDir = normalize(_WorldSpaceCameraPos.xyz - input.worldPos);
                half3 reflectDir = normalize(reflect(mainLight.direction, input.worldNormal));
                float spec = pow(saturate(dot(viewDir, -reflectDir)), _Gloss);
                half3 specular = _BaseColor.xyz * spec;

                // 获取环境光方式多种，且得到效果不一
                //half3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //half3 ambient = (glstate_lightmodel_ambient).xyz;
                //half3 ambient = i.vertexSH.xyz;
                //half3 ambient = SampleSH(worldNormal);
                half3 ambient = _GlossyEnvironmentColor;
                //half3 ambient = half3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w) ;
                //half3 ambient = SAMPLE_GI(i.lightmapUV, i.vertexSH, worldNormal);
                //half3 ambient =unity_AmbientEquator; ;

                half4 output = _BaseColor * half4(diffuse + _GlossyEnvironmentColor + specular, 1); //将表面颜色，漫反射强度混合。
                return output;
            }
            ENDHLSL
        }
    }
}