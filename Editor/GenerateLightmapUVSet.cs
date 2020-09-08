/**************************************************************************
 * Copyright 2020 ArsMania
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
**************************************************************************/

using UnityEditor;
using UnityEngine;

namespace SonicUnleashed.Editor
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