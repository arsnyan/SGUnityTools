using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEngine;

namespace SonicUnleashed.Editor
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

        [MenuItem("GameObject/Use mesh from active", false, -100)]
        public static void InstanceMesh(MenuCommand command)
        {
            var selected = Selection.activeGameObject;
            var meshFilters = selected.GetComponentsInChildren<MeshFilter>();

            Undo.RegisterFullObjectHierarchyUndo(selected, "Undo instancing");
            for (int i = 1; i < meshFilters.Length; i++)
            {
                meshFilters[i].sharedMesh = meshFilters[0].sharedMesh;
            }
        }
        
        [MenuItem("GameObject/Filter objects and instance", false, -105)]
        public static void FilterAndInstanceMesh(MenuCommand command)
        {
            var selected = Selection.activeGameObject;
            var meshFilters = selected.GetComponentsInChildren<MeshFilter>();
            var dict = new Dictionary<KeyValuePair<String, int>, MeshFilter>();

            Undo.RegisterFullObjectHierarchyUndo(selected, "Undo instancing");

            for (int i = 0; i < meshFilters.Length; i++)
            {
                string name;
                KeyValuePair<String, int> keyValue;
                if (i < 0)
                {
                    name = Regex.Match(meshFilters[i].name, @"^[^0-9]*").Value.Trim();
                    keyValue = new KeyValuePair<String, int>(name, meshFilters[i].sharedMesh.vertexCount);
                }
                else
                {
                    name = meshFilters[i].name;
                    keyValue = new KeyValuePair<String, int>(name, meshFilters[i].sharedMesh.vertexCount);
                }

                dict[keyValue] = meshFilters[i];
            }

            dict = dict
                .OrderBy(obj => obj.Key.Key)
                .ToDictionary(
                    k => k.Key, 
                    v => v.Value
                    );
            
            var previousPair = dict.Keys.First();
            var instancedMesh = dict.Values.First().sharedMesh;
            foreach (var keyValuePair in dict)
            {
                var name = Regex.Match(keyValuePair.Key.Key, @"^[^0-9]*").Value.Trim();
                var vertexCount = keyValuePair.Value.sharedMesh.vertexCount;
                if (vertexCount.Equals(previousPair.Value) && previousPair.Key.Contains(name))
                {
                    var dictFilter = dict[keyValuePair.Key];
                    dictFilter.sharedMesh = instancedMesh;
                }
                else
                {
                    instancedMesh = dict[keyValuePair.Key].sharedMesh;
                }

                var currPair = new KeyValuePair<String, int>(name, vertexCount);

                previousPair = currPair;
            }
        }
    }
}