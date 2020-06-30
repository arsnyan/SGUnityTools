using System;
using System.Collections.Generic;
using HedgeLib.Materials;
using UnityEditor.Experimental.AssetImporters;
using UnityEngine;

namespace Editor
{
    [ScriptedImporter(1, "material")]
    public class SGMaterialImporter : ScriptedImporter
    {
        private static readonly int Albedo = Shader.PropertyToID("_Albedo");
        private static readonly int Normal = Shader.PropertyToID("_Normal");
        private static readonly int Specular = Shader.PropertyToID("_Specular");
        private static readonly int Smoothness = Shader.PropertyToID("_Smoothness");
        private static readonly int AmbientOcclusion = Shader.PropertyToID("_AO");
        private static readonly int Translucency = Shader.PropertyToID("_TranslucencyTex");
        
        private static readonly int Albedo1 = Shader.PropertyToID("_Albedo1");
        private static readonly int Albedo2 = Shader.PropertyToID("_Albedo2");
        private static readonly int Normal1 = Shader.PropertyToID("_Normal1");
        private static readonly int Normal2 = Shader.PropertyToID("_Normal2");

        public override void OnImportAsset(AssetImportContext ctx)
        {
            var mtlLoader = new HedgeLib.Materials.GensMaterial();
            mtlLoader.Load(ctx.assetPath);

            var shaderName = mtlLoader.ShaderName;
            Material mtl;
            if (IsOpaque(shaderName) && !IsTransparent(shaderName))
            {
                mtl = new Material(Shader.Find("Lit Surface"));

                var textures = mtlLoader.Texset.Textures;

                foreach (var tex in textures)
                {
                    var texTextureName = tex.TextureName;
                    var ldt = Resources.Load<Texture2D>($"Textures/{texTextureName}");
                    
                    CheckAndSet(ref mtl, texTextureName, "_dif", Albedo, ldt);
                    CheckAndSet(ref mtl, texTextureName, "_nrm", Normal, ldt);
                    CheckAndSet(ref mtl, texTextureName, "_spc", Specular, ldt);
                    CheckAndSet(ref mtl, texTextureName, "_pow", Smoothness, ldt);
                    CheckAndSet(ref mtl, texTextureName, "_ao", AmbientOcclusion, ldt);
                }
                
                ctx.AddObjectToAsset("Material", mtl);
            }
            else if (IsTransparent(shaderName))
            {
                var textures = mtlLoader.Texset.Textures;
                var texNames = "";
                textures.ForEach(texture => texNames += texture.TextureName + " ");

                if (texNames.Contains("_trs"))
                {
                    mtl = new Material(Shader.Find("TranslucentCutoff"));

                    foreach (var tex in textures)
                    {
                        var texTextureName = tex.TextureName;
                        var ldt = Resources.Load<Texture2D>($"Textures/{texTextureName}");

                        CheckAndSet(ref mtl, texTextureName, "_dif", Albedo, ldt);
                        CheckAndSet(ref mtl, texTextureName, "_nrm", Normal, ldt);
                        CheckAndSet(ref mtl, texTextureName, "_pow", Smoothness, ldt);
                        CheckAndSet(ref mtl, texTextureName, "_trs", Translucency, ldt);
                    }
                }
                else
                {
                    mtl = new Material(Shader.Find("Cutoff"));
                    
                    foreach (var tex in textures)
                    {
                        var texTextureName = tex.TextureName;
                        var ldt = Resources.Load<Texture2D>($"Textures/{texTextureName}");

                        CheckAndSet(ref mtl, texTextureName, "_dif", Albedo, ldt);
                        CheckAndSet(ref mtl, texTextureName, "_nrm", Normal, ldt);
                    }
                }

                ctx.AddObjectToAsset("Material", mtl);
            }
            else if (shaderName.Contains("Blend"))
            {
                try
                {
                    mtl = new Material(Shader.Find("Vertex Color Blend"));

                    var textures = mtlLoader.Texset.Textures;

                    var firstElement = textures[0];
                    var firstBlend =
                        firstElement.TextureName.Remove(
                            firstElement.TextureName.IndexOf(".png", StringComparison.Ordinal) - 3);
                    
                    foreach (var tex in textures)
                    {
                        var texTextureName = tex.TextureName;
                        var ldt = Resources.Load<Texture2D>($"Textures/{texTextureName}");

                        if (firstBlend == texTextureName)
                        {
                            CheckAndSet(ref mtl, texTextureName, "_dif", Albedo1, ldt);
                            CheckAndSet(ref mtl, texTextureName, "_nrm", Normal1, ldt);
                        }
                        else
                        {
                            CheckAndSet(ref mtl, texTextureName, "_dif", Albedo2, ldt);
                            CheckAndSet(ref mtl, texTextureName, "_nrm", Normal2, ldt);
                        }
                    }
                    
                    ctx.AddObjectToAsset("Material", mtl);
                }
                catch (Exception e)
                {
                    ctx.AddObjectToAsset("TexsetDesc", FalloffDescription(mtlLoader));
                }
            }
            else 
                FalloffDescription(mtlLoader);
        }

        private bool CheckAndSet(ref Material mtl, string name, string filter, int nameId, Texture2D texture2D)
        {
            if (name.Contains(filter))
            {
                mtl.SetTexture(nameId, texture2D);
                return true;
            }
            else
                return false;
        }

        private bool IsOpaque(string shaderName)
        {
            return shaderName.Contains("Common") || shaderName.Contains("Ice");
        }

        private bool IsTransparent(string shaderName)
        {
            return shaderName == "Common_dp" || shaderName == "Common_dn" || shaderName == "Common_d";
        }

        private TextAsset FalloffDescription(GensMaterial mtlLoader)
        {
            var texs = mtlLoader.Texset.Textures;
            var count = texs.Count;
            List<string> names = new List<string>();
            foreach (var tex in texs)
            {
                names.Add(tex.TextureName);
            }

            var docText
                = $"{String.Join(", ", names)} | shader name - {mtlLoader.ShaderName + " " + mtlLoader.SubShaderName}";
                
            return new TextAsset(docText);
        }
    }
}