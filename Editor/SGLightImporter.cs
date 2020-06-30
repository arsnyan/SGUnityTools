using UnityEditor.Experimental.AssetImporters;
using UnityEngine;

namespace Editor
{
    [ScriptedImporter(1, "light")]
    public class SGLightImporter : ScriptedImporter
    {
	    public override void OnImportAsset(AssetImportContext ctx)
        {
            var lightObj = new GameObject("Light Source");
            var light = lightObj.AddComponent<Light>();

            var hedgeLight = new HedgeLib.Lights.Light();
            hedgeLight.Load(ctx.assetPath);

            var pos = hedgeLight.Position;
            var col = hedgeLight.Color;
            if (hedgeLight.LightType == HedgeLib.Lights.Light.LightTypes.Directional)
            {
                lightObj.transform.position = Vector3.zero;
                lightObj.transform.rotation = Quaternion.LookRotation(new Vector3(pos.X, pos.Y, pos.Z));
                
                light.type = LightType.Directional;
                light.shadows = LightShadows.Soft;
                light.color = new Color(col.X, col.Y, col.Z);
                light.intensity = 1f;
                light.lightmapBakeType = LightmapBakeType.Mixed;
            }
            else
            {
                lightObj.transform.position = new Vector3(pos.X, pos.Y, pos.Z);

                light.type = LightType.Point;
                light.shadows = LightShadows.Hard;
                light.color = new Color(col.X, col.Y, col.Z);
                light.intensity = 1f;
                light.range = hedgeLight.OmniOuterRange;
                light.lightmapBakeType = LightmapBakeType.Baked;
            }
            
            ctx.AddObjectToAsset("Light", lightObj);
        }
    }
}
