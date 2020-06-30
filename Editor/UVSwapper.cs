using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace Editor
{
    public class UVSwapper : MonoBehaviour
    {
        [MenuItem("GameObject/Swap UV's", false, 0)]
        public static void SwapUVs(MenuCommand command)
        {
            var selected = Selection.gameObjects;
            
            foreach (var obj in selected)
            {
                var mesh = obj.GetComponent<MeshFilter>().sharedMesh;
                var uv1 = new List<Vector2>();
                mesh.GetUVs(1, uv1);
                mesh.SetUVs(2, uv1);
            }
        }
    }
}
