// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lit Surface"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		[Normal]_Normal("Normal", 2D) = "white" {}
		_Specular("Specular", 2D) = "white" {}
		_Smoothness("Smoothness", 2D) = "white" {}
		_AO("AO", 2D) = "white" {}
		_SpecularInput("[SPC] Specular Value", Range( 0 , 1)) = 0
		_SmoothnessInput("Smoothness Value", Range( 0 , 1)) = 0
		_AOInput("AO Value", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.5
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows nofog nometa 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _Specular;
		uniform float4 _Specular_ST;
		uniform float _SpecularInput;
		uniform sampler2D _Smoothness;
		uniform float4 _Smoothness_ST;
		uniform float _SmoothnessInput;
		uniform sampler2D _AO;
		uniform float4 _AO_ST;
		uniform float _AOInput;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 tex2DNode12 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float4 color10 = IsGammaSpace() ? float4(1,1,0,0) : float4(1,1,0,0);
			float3 appendResult26 = (float3(tex2DNode12.r , ( 1.0 - tex2DNode12.g ) , tex2DNode12.b));
			o.Normal = (( tex2DNode12 == color10.rgb ) ? float3(0,0,1) :  appendResult26 );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = tex2D( _Albedo, uv_Albedo ).rgb;
			float2 uv_Specular = i.uv_texcoord * _Specular_ST.xy + _Specular_ST.zw;
			float4 tex2DNode15 = tex2D( _Specular, uv_Specular );
			float4 color4 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 temp_cast_2 = (_SpecularInput).xxxx;
			o.Specular = (( tex2DNode15 == color4 ) ? temp_cast_2 :  tex2DNode15 ).rgb;
			float2 uv_Smoothness = i.uv_texcoord * _Smoothness_ST.xy + _Smoothness_ST.zw;
			float4 tex2DNode18 = tex2D( _Smoothness, uv_Smoothness );
			float4 temp_cast_4 = (_SmoothnessInput).xxxx;
			o.Smoothness = (( tex2DNode18 == color4 ) ? temp_cast_4 :  tex2DNode18 ).r;
			float2 uv_AO = i.uv_texcoord * _AO_ST.xy + _AO_ST.zw;
			float4 tex2DNode24 = tex2D( _AO, uv_AO );
			float4 temp_cast_6 = (_AOInput).xxxx;
			o.Occlusion = (( tex2DNode24 == color4 ) ? temp_cast_6 :  tex2DNode24 ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;0;1366;717;194.1823;-398.0698;1;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;11;-614.7369,73.74046;Inherit;True;Property;_Normal;Normal;1;1;[Normal];Create;True;0;0;False;0;None;6de2ac7e3b5261649aa69df5a6987d67;True;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;12;-304.5295,69.38068;Inherit;True;Property;_AlbedoSampler2D1;_AlbedoSampler2D;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;28;17.68825,213.6893;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;14;-320.4676,520.8224;Inherit;True;Property;_Specular;Specular;2;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;16;-258.5114,888.8184;Inherit;True;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;False;0;None;58761084109720c40a75f565df201bf9;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;25;-253.4333,1289.62;Inherit;True;Property;_AO;AO;4;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;213.8713,191.5369;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;10;-123.5835,311.8525;Inherit;False;Constant;_Color1;Color 1;1;0;Create;True;0;0;False;0;1,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;24;0.1539993,1099.29;Inherit;True;Property;_AlbedoSamplerD4;_AlbedoSampler2D;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;4.461357,1004.985;Inherit;False;Property;_SmoothnessInput;Smoothness Value;6;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-6.795975,797.7011;Inherit;True;Property;_AlbedoSamplerD3;_AlbedoSampler2D;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;9.539398,1310.316;Inherit;False;Property;_AOInput;AO Value;7;0;Create;False;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-259.0653,715.1978;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-10.79565,718.6425;Inherit;False;Property;_SpecularInput;[SPC] Specular Value;5;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;13;107.4012,367.6631;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;15;-12.46146,520.4628;Inherit;True;Property;_AlbedoSampler2D2;_AlbedoSampler2D;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;1;34.17977,-55.81985;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;None;b378b9158fd2d04498cbfe9a08726454;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TFHCCompareEqual;7;413.7855,522.2904;Inherit;False;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;401.2823,116.4484;Inherit;True;Property;_AlbedoSampler2D;_AlbedoSampler2D;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCCompareEqual;19;417.5789,672.2355;Inherit;False;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCCompareEqual;8;427.1146,364.9258;Inherit;False;4;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCCompareEqual;21;435.7606,829.6829;Inherit;False;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;917.4991,456.3541;Float;False;True;-1;3;ASEMaterialInspector;0;0;StandardSpecular;Lit Surface;False;False;False;False;False;False;False;False;False;True;True;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;11;0
WireConnection;28;0;12;2
WireConnection;26;0;12;1
WireConnection;26;1;28;0
WireConnection;26;2;12;3
WireConnection;24;0;25;0
WireConnection;18;0;16;0
WireConnection;15;0;14;0
WireConnection;7;0;15;0
WireConnection;7;1;4;0
WireConnection;7;2;9;0
WireConnection;7;3;15;0
WireConnection;2;0;1;0
WireConnection;19;0;18;0
WireConnection;19;1;4;0
WireConnection;19;2;20;0
WireConnection;19;3;18;0
WireConnection;8;0;12;0
WireConnection;8;1;10;0
WireConnection;8;2;13;0
WireConnection;8;3;26;0
WireConnection;21;0;24;0
WireConnection;21;1;4;0
WireConnection;21;2;23;0
WireConnection;21;3;24;0
WireConnection;0;0;2;0
WireConnection;0;1;8;0
WireConnection;0;3;7;0
WireConnection;0;4;19;0
WireConnection;0;5;21;0
ASEEND*/
//CHKSM=7ED249481503090D47DB845F1325F46A02BC16A8