using System;
using UnityEngine;


public class Box : MonoBehaviour {

    private MeshRenderer m_meshRenderer;

    private void Start() {
        m_meshRenderer = GetComponent<MeshRenderer>();
    }

    private void Update() {
        Vector4 outPos = m_meshRenderer.material.GetVector("_OutPos");
        Debug.Log(outPos);
    }
}