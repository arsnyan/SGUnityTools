using UnityEditor;
using UnityEngine;

namespace Editor
{
    public class GenerateLightmapUVSet : MonoBehaviour
    {
        [MenuItem("GameObject/Generate Lightmap UV\'s", false, 0)]
        public static void BatchObjects(MenuCommand command)
        {
            foreach (var obj in Selection.gameObjects)
                Unwrapping.GenerateSecondaryUVSet(obj.GetComponent<MeshFilter>().sharedMesh);
        }
    }
}