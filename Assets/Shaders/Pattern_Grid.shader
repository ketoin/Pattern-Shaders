
Shader "Pattern_Grid"
{
	Properties
	{
		_Texture("Texture", 2D) = "white" {}
		_Color1("Color 1", Color) = (0,0,0,0)
		_Color0("Color 0", Color) = (1,1,1,0)
		_Rotation("Rotation", Float) = 0
		_Tiling("Tiling", Float) = 16
		_GridWidth("Grid Width", Float) = 0.5
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float4 _Color1;
		uniform float4 _Color0;
		uniform float _GridWidth;
		uniform float _Tiling;
		uniform float _Rotation;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float3 _vertexPos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float cosRes = cos( _Rotation );
			float sinRes = sin( _Rotation );
			float2 rotator = mul( ( _Tiling * _vertexPos ).xy - float2( 0,0 ) , float2x2( cosRes , -sinRes , sinRes , cosRes )) + float2( 0,0 );
			float4 lerpResult = lerp( _Color1 , _Color0 , floor( ( _GridWidth + frac( min( ( 1.0 - frac( rotator.y ) ) , frac( rotator.x ) ) ) ) ));
			o.Albedo = ( tex2D( _Texture, uv_Texture ) * lerpResult ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}