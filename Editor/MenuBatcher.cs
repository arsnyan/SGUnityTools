using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEngine;

namespace Editor
{
    public class MenuBatcher : MonoBehaviour
    {
        /**
         * <summary>
         * This function returns distance from pivot point of object to first vertex in mesh filter.
         * </summary>
         * 
         * This can be made with more precision if you just perform arithmetical operation with the first vertex
         * and some others, like second or third for example. (as you use more vertices in calculation)
         */
        private static float DistancesToVerts(MeshFilter filter)
        {
            var mesh = filter.sharedMesh;

            var localPosition = filter.transform.localPosition;
            /*
             * To get vertices relative to pivot point of the object, I add local position to vertex position.
             */
            return Vector3.Distance(localPosition, mesh.vertices[0] + localPosition);
        }

        /**
         * Used to combine multiple objects. All of them then parented to first element in selection.
         * Then used for static batching, none of the objects cannot be individually moved. Not applicable to parent object.
         * Can be used only on sequence of objects, but not on children of game object.
         */
        [MenuItem("GameObject/Batch objects", false, 0)]
        public static void BatchObjects(MenuCommand command)
        {
            var selected = Selection.gameObjects;
            var first = selected[0];

            // Used to register action, to be able to undo batching. Doesn't work though.
            // ReSharper disable once CoVariantArrayConversion
            Undo.RegisterCompleteObjectUndo(selected, "Undo instancing");
            
            // Combines objects, then parents all of them the firstly selected one
            StaticBatchingUtility.Combine(selected, first);
            for (var i = 1; i < selected.Length; i++)
                selected[i].transform.SetParent(first.transform);
        }

        /**
         * Replace all children mesh with parents one to enable instancing
         * TODO(Actually it should somehow work without parenting, but not sure how)
         */
        [MenuItem("GameObject/Use mesh from active", false, -100)]
        public static void InstanceMesh(MenuCommand command)
        {
            var selected = Selection.activeGameObject;
            var meshFilters = selected.GetComponentsInChildren<MeshFilter>();

            Undo.RegisterFullObjectHierarchyUndo(selected, "Undo instancing");
            for (var i = 1; i < meshFilters.Length; i++) meshFilters[i].sharedMesh = meshFilters[0].sharedMesh;
        }

        /**
         * Filters objects by their names, then compares every object by previous one if it has
         * same amount of vertices, starts with the same name and has the same pivot point location
         * with accuracy 1f.
         *
         * TODO(Make it work without numeration of objects)
         */
        [MenuItem("GameObject/Filter objects and instance", false, -105)]
        public static void FilterAndInstanceMesh(MenuCommand command)
        {
            /*
             * It's cleaner to just get components from children objects to get all needed values.
             */
            var selected = Selection.activeGameObject;
            var meshFilters = selected.GetComponentsInChildren<MeshFilter>();
            // Uses dictionary to store mesh filters by key pair of name and vertices count
            var dict = new Dictionary<KeyValuePair<string, int>, MeshFilter>();

            // Makes it possible to undo operations
            Undo.RegisterFullObjectHierarchyUndo(selected, "Undo instancing");

            // Browse through all selected mesh filters to store them in dictionary with keys.
            // This is mostly non-understandable, so comments don't exactly describe why this is written this way.
            for (var i = 0; i < meshFilters.Length; i++)
            {
                string name;
                KeyValuePair<string, int> keyValue;
                
                // Probably useless expression, but at first I wanted to use it only for the first object in dictionary
                if (i < 0)
                {
                    // Here the name of mesh filter is cropped to the start of digit numeration
                    name = Regex.Match(meshFilters[i].name, @"^[^0-9]*").Value.Trim();
                    keyValue = new KeyValuePair<string, int>(name, meshFilters[i].sharedMesh.vertexCount);
                }
                else
                {
                    name = meshFilters[i].name;
                    // This creates a key for mesh filter in dictionary, so that I can access it in comparison 
                    keyValue = new KeyValuePair<string, int>(name, meshFilters[i].sharedMesh.vertexCount);
                }

                dict[keyValue] = meshFilters[i];
            }

            // Sorts dictionary by mesh filter's name in alphabetic order
            dict = dict
                .OrderBy(obj => obj.Key.Key)
                .ToDictionary(k => k.Key, v => v.Value);

            // First pair and instanced mesh is always first element in sorted dictionary
            var previousPair = dict.Keys.First();
            var instancedMesh = dict.Values.First();
            // Browse through all elements in dictionary, getting its key
            foreach (var keyValuePair in dict)
            {
                // Concat name to the beginning of digit numeration (again)
                var name = Regex.Match(keyValuePair.Key.Key, @"^[^0-9]*").Value.Trim();
                // Get vertex count in mesh
                var vertexCount = keyValuePair.Value.sharedMesh.vertexCount;

                /*
                 * This checks if (AND):
                 * vertex count is equal to previous' instance
                 * previous key's name contained new name
                 * the last comparison is basically a way to solve expression distance1 == distance2,
                 * as it lose a lot of precision. Then it takes absolute value which makes equation
                 * normalized. Everything, that is less than 1f
                 * (calculation accuracy, or maximum acceptable distance between real pivot point and margined one)
                 * can return true in condition
                 */
                if (
                    vertexCount.Equals(previousPair.Value)
                    && previousPair.Key.Contains(name)
                    && Math.Abs(
                        DistancesToVerts(instancedMesh) - DistancesToVerts(keyValuePair.Value)
                    ) < 1f
                )
                    // In case current mesh is same as previous one, it assigns previous one to current one
                    dict[keyValuePair.Key].sharedMesh = instancedMesh.sharedMesh;
                else
                    // In case current mesh differs or have different pivot point, current mesh becomes instancing mesh.
                    instancedMesh = dict[keyValuePair.Key];
                
                // Everytime new pair is made for further comparison
                previousPair = new KeyValuePair<string, int>(name, vertexCount);
            }
        }
    }
}