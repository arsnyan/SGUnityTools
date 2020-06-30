using UnityEditor;
using UnityEngine;

namespace Editor
{
    public class MenuBatcher : MonoBehaviour
    {
        [MenuItem("GameObject/Batch objects", false, 0)]
        public static void BatchObjects(MenuCommand command)
        {
            var selected = Selection.gameObjects;
            var first = selected[0];
            
            StaticBatchingUtility.Combine(selected, first);
            for (int i = 1; i < selected.Length; i++)
                selected[i].transform.SetParent(first.transform);
        }
    }
}
