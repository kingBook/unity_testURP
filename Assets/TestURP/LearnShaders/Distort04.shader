Shader "Unlit/Unlit/Distort04" {
    Properties {
        _DistortTex ("Texture", 2D) = "white" {}
        _DistortValue("DistortValue",Range(0,1)) = 1
        _DistortSpeed("DistortSpeed",float) = 1
        _Radius ( "_Radius",float ) =1
    }
    SubShader {
        Tags {
            "Queue"="Transparent"
        }
        LOD 100
        Cull off

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 maskUV : TEXCOORD1;
                float4 vertex : SV_POSITION;
                float4 screenUV : TEXCOORD2;
            };

            sampler2D _GrabTex;
            sampler2D _DistortTex;
            float4 _DistortTex_ST;
            fixed _DistortValue;
            float _DistortSpeed;
            float _Radius;

            v2f vert(appdata v)
            {
                v2f o;
                o.uv = TRANSFORM_TEX(v.uv, _DistortTex);
                o.maskUV = v.uv;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenUV = ComputeScreenPos(o.vertex); //根据不同平台匹配屏幕坐标（DX或opengl）

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 distortTex = tex2D(_DistortTex, i.uv.xy + _Time.xy * _DistortSpeed);

                float fade = pow(1 - length(i.maskUV - 0.5), _Radius);

                fixed4 grabTex = tex2Dproj(_GrabTex, lerp(i.screenUV, distortTex * fade, _DistortValue)); //和下面的结果一样

                return grabTex;
            }
            ENDCG
        }
    }
}