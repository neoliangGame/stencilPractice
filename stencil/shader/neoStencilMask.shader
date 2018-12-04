Shader "neo/neoStencilMask"
{
	Properties
	{
		_Stencil("Stencil ID", Float) = 0
		//_StencilComp("Stencil Comparison", Float) = 8
		//_StencilOp("Stencil Operation", Float) = 0
		//_StencilWriteMask("Stencil Write Mask", Float) = 255
		//_StencilReadMask("Stencil Read Mask", Float) = 255
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue" = "Geometry-1" }
		Cull Back
		ZWrite Off
		ColorMask 0
		LOD 100

		Pass
		{
			Stencil
			{
				Ref [_Stencil]
				Comp Always //Always = 0 ,Never = 1, Great, Equal, GEqual, Less, NotEqual, LessEqual = 7 （环）
				Pass Replace	//Keep = 0, Zero, Replace, Incrsat, Invert, IncrWrap, DecrWrap = 7 （环）
				//ReadMask [_StencilReadMask]
				//WriteMask [_StencilWriteMask]
			}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return (0,0,0,0);
			}
			ENDCG
		}
	}
}
