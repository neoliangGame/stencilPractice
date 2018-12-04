Shader "neo/neoStencilShow"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_ColorStrength("Color Strength", Range(0,1)) = 0.5

		_Stencil("Stencil ID", Float) = 0
		//_StencilComp("Stencil Comparison", Float) = 8
		//_StencilOp("Stencil Operation", Float) = 0
		//_StencilWriteMask("Stencil Write Mask", Float) = 255
		//_StencilReadMask("Stencil Read Mask", Float) = 255
	}
	SubShader
	{
		Tags{ "RenderType" = "Opaque" "Queue" = "Geometry" }
		Cull Off
		LOD 100

		Pass
		{

			Stencil
			{
				Ref [_Stencil]
				Comp Equal //Aways = 0 ,Never = 1, Great, Equal, GEqual, Less, NotEqual, LessEqual = 7 （环）
				Pass Keep	//Keep = 0, Zero, Replace, Incrsat, Invert, IncrWrap, DecrWrap = 7 （环）
				//ReadMask[_StencilReadMask]
				//WriteMask[_StencilWriteMask]
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				half3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 light : COLOR0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			float4 _Color;
			float _ColorStrength;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				half3 lightDir = normalize(ObjSpaceLightDir(v.vertex));
				half3 normalDir = normalize(v.normal);
				o.light = 1 - min(dot(normalDir, lightDir) * 0.4 + 0.5, 1);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col *= i.light;
				col = (1 - _ColorStrength) * col + _Color * _ColorStrength;
				return col;
			}
			ENDCG
		}
	}
}
