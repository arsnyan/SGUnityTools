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

using System;
using UnityEditor;
using UnityEngine;

namespace SonicUnleashed.Editor
{
    public class ScreenshotTool : EditorWindow
    {
        private static string _fileName = "Screenshot_";
        private static int _sizeScale = 1;

        private static DateTime _dt;

        public void OnGUI()
        {
            _fileName = EditorGUILayout.TextField("File name", _fileName);
            _sizeScale = EditorGUILayout.IntField("Size scale", _sizeScale);

            if (GUILayout.Button("Take a screenshot"))
            {
                ScreenCapture.CaptureScreenshot($"{_fileName + _dt.Month + _dt.Day + _dt.Hour + _dt.Second}.png",
                    _sizeScale);
                Debug.Log("Screenshot is saved");
            }
        }

        [MenuItem("Window/Take a screenshot")]
        public static void Init()
        {
            var window = GetWindow(typeof(ScreenshotTool));
            _dt = new DateTime();
            window.Show();
        }
    }
}