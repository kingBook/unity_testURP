using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class BoxCreator : MonoBehaviour {

    public GameObject boxPrefab;
    public int size = 10;
    private static readonly int s_baseColor = Shader.PropertyToID("_BaseColor");

    
    
    private void Start() {
        MaterialPropertyBlock materialPropertyBlock = new MaterialPropertyBlock();
        
        float space = 2f;
        float halfTotalWidth = size * space * 0.5f;
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                var inst = Instantiate(boxPrefab, boxPrefab.transform.parent);
                inst.transform.localPosition =
                        new Vector3(j * space - halfTotalWidth, 0f, i * space - halfTotalWidth);


                var renderer = inst.GetComponent<MeshRenderer>();
                // 改变颜色，方法1
                 materialPropertyBlock.SetColor(s_baseColor,Random.ColorHSV());
                 renderer.SetPropertyBlock(materialPropertyBlock);
                
                // 改变颜色，方法2
                //renderer.material.SetColor(s_baseColor, Random.ColorHSV());
                
            }
        }
        boxPrefab.SetActive(false);
    }
}