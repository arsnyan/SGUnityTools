// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Vertex Color Blend"
{
	Properties
	{
		_Albedo1("Albedo 1", 2D) = "white" {}
		_Albedo2("Albedo 2", 2D) = "white" {}
		_Normal1("Normal 1", 2D) = "white" {}
		_Normal2("Normal 2", 2D) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Specular("Specular", Range( 0 , 1)) = 0
		_AO("AO", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Normal2;
		uniform float4 _Normal2_ST;
		uniform sampler2D _Normal1;
		uniform float4 _Normal1_ST;
		uniform sampler2D _Albedo2;
		uniform float4 _Albedo2_ST;
		uniform sampler2D _Albedo1;
		uniform float4 _Albedo1_ST;
		uniform float _Specular;
		uniform float _Smoothness;
		uniform float _AO;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Normal2 = i.uv_texcoord * _Normal2_ST.xy + _Normal2_ST.zw;
			float3 tex2DNode12 = UnpackNormal( tex2D( _Normal2, uv_Normal2 ) );
			float4 color19 = IsGammaSpace() ? float4(1,1,0,0) : float4(1,1,0,0);
			float3 _Vector1 = float3(0,0,1);
			float3 appendResult28 = (float3(tex2DNode12.r , ( 1.0 - tex2DNode12.g ) , tex2DNode12.b));
			float3 temp_output_22_0 = (( tex2DNode12 == color19.rgb ) ? _Vector1 :  appendResult28 );
			float2 uv_Normal1 = i.uv_texcoord * _Normal1_ST.xy + _Normal1_ST.zw;
			float3 tex2DNode10 = UnpackNormal( tex2D( _Normal1, uv_Normal1 ) );
			float3 appendResult27 = (float3(tex2DNode10.r , ( 1.0 - tex2DNode10.g ) , tex2DNode10.b));
			float3 lerpResult15 = lerp( temp_output_22_0 , (( tex2DNode10 == color19.rgb ) ? _Vector1 :  appendResult27 ) , i.vertexColor.b);
			float3 lerpResult13 = lerp( lerpResult15 , temp_output_22_0 , i.vertexColor.g);
			float3 lerpResult14 = lerp( lerpResult13 , temp_output_22_0 , i.vertexColor.r);
			o.Normal = lerpResult14;
			float2 uv_Albedo2 = i.uv_texcoord * _Albedo2_ST.xy + _Albedo2_ST.zw;
			float4 tex2DNode7 = tex2D( _Albedo2, uv_Albedo2 );
			float2 uv_Albedo1 = i.uv_texcoord * _Albedo1_ST.xy + _Albedo1_ST.zw;
			float4 lerpResult1 = lerp( tex2DNode7 , tex2D( _Albedo1, uv_Albedo1 ) , i.vertexColor.b);
			float4 lerpResult2 = lerp( lerpResult1 , tex2DNode7 , i.vertexColor.g);
			float4 lerpResult3 = lerp( lerpResult2 , tex2DNode7 , i.vertexColor.r);
			o.Albedo = lerpResult3.rgb;
			float3 temp_cast_5 = (_Specular).xxx;
			o.Specular = temp_cast_5;
			o.Smoothness = _Smoothness;
			o.Occlusion = _AO;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;0;1366;717;2159.239;9.499527;1.782538;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;11;-1667.078,973.4281;Inherit;True;Property;_Normal2;Normal 2;3;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;9;-1655.372,497.3753;Inherit;True;Property;_Normal1;Normal 1;2;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;12;-1384.964,982.7444;Inherit;True;Property;_TextureSample3;Texture Sample 0;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;-1373.258,506.6916;Inherit;True;Property;_TextureSample2;Texture Sample 0;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;26;-1049.843,653.053;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;29;-1037.475,1183.624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;6;-1209.064,66.82513;Inherit;True;Property;_Albedo2;Albedo 2;1;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ColorNode;19;-1577.757,749.0696;Inherit;False;Constant;_Color2;Color 1;1;0;Create;True;0;0;False;0;1,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;17;-1339.284,780.5448;Inherit;False;Constant;_Vector1;Vector 0;2;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;28;-872.4747,1166.624;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;27;-948.8433,740.053;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-1205.001,-156.4797;Inherit;True;Property;_Albedo1;Albedo 1;0;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.VertexColorNode;8;-842.2438,310.6679;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-926.95,76.14143;Inherit;True;Property;_TextureSample1;Texture Sample 0;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-924.6702,-147.1634;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCCompareEqual;18;-783.2474,571.3864;Inherit;False;4;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCCompareEqual;22;-718.693,1003.952;Inherit;False;4;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;1;-585,-110.5;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;15;-576.5649,529.3465;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;2;-365,-51.5;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;13;-356.5649,588.3465;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;14;-135.5649,617.3465;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;25;74.11969,762.4476;Inherit;False;Property;_AO;AO;6;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;3;-144,-22.5;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;23;67.11969,668.4476;Inherit;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;83.11969,486.4476;Inherit;False;Property;_Specular;Specular;5;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;394.3426,446.7957;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Vertex Color Blend;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;11;0
WireConnection;10;0;9;0
WireConnection;26;0;10;2
WireConnection;29;0;12;2
WireConnection;28;0;12;1
WireConnection;28;1;29;0
WireConnection;28;2;12;3
WireConnection;27;0;10;1
WireConnection;27;1;26;0
WireConnection;27;2;10;3
WireConnection;7;0;6;0
WireConnection;5;0;4;0
WireConnection;18;0;10;0
WireConnection;18;1;19;0
WireConnection;18;2;17;0
WireConnection;18;3;27;0
WireConnection;22;0;12;0
WireConnection;22;1;19;0
WireConnection;22;2;17;0
WireConnection;22;3;28;0
WireConnection;1;0;7;0
WireConnection;1;1;5;0
WireConnection;1;2;8;3
WireConnection;15;0;22;0
WireConnection;15;1;18;0
WireConnection;15;2;8;3
WireConnection;2;0;1;0
WireConnection;2;1;7;0
WireConnection;2;2;8;2
WireConnection;13;0;15;0
WireConnection;13;1;22;0
WireConnection;13;2;8;2
WireConnection;14;0;13;0
WireConnection;14;1;22;0
WireConnection;14;2;8;1
WireConnection;3;0;2;0
WireConnection;3;1;7;0
WireConnection;3;2;8;1
WireConnection;0;0;3;0
WireConnection;0;1;14;0
WireConnection;0;3;24;0
WireConnection;0;4;23;0
WireConnection;0;5;25;0
ASEEND*/
//CHKSM=FF3272DB302A2974EC14FCB176B9D2EBDDE02EBD