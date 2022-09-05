using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class ShowFPS : MonoBehaviour {

    private TMP_Text m_text;

	void Start () {
        m_text = GetComponent<TMP_Text>();
	}
	
	void Update () {
        float fps = 1.0f / Time.smoothDeltaTime;
        m_text.text = "FPS: " + fps.ToString();
    }
}
