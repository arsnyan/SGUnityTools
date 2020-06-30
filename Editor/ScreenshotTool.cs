using System;
using UnityEditor;
using UnityEngine;

namespace Editor
{
	public class ScreenshotTool : EditorWindow
	{
		private static string _fileName = "Screenshot_";
		private static int _sizeScale = 1;
	
		private static DateTime _dt;
	
		[MenuItem("Window/Take a screenshot")]
		public static void Init()
		{
			EditorWindow window = GetWindow(typeof(ScreenshotTool));
			_dt = new DateTime();
			window.Show();
		}

		public void OnGUI()
		{
			_fileName = EditorGUILayout.TextField("File name", _fileName);
			_sizeScale = EditorGUILayout.IntField("Size scale", _sizeScale);
		
			if (GUILayout.Button("Take a screenshot"))
			{
				ScreenCapture.CaptureScreenshot($"{_fileName + _dt.Month + _dt.Day + _dt.Hour + _dt.Second}.png", _sizeScale);
				Debug.Log("Screenshot is saved");
			}
		}
	}
}
