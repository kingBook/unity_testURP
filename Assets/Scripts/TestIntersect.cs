using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestIntersect : MonoBehaviour {

    public Transform a;
    public Transform b;
    public Transform c;
    public Transform d;

    public Transform o;

    private void Update() {
        /*Vector3 ab = b.position - a.position;
        Vector3 ab0 = ab.normalized;
        Vector3 cd = d.position - c.position;
        Vector3 cd0 = cd.normalized;
        Vector3 ca = a.position - c.position;

        // 是否平行
        bool isParallel = Vector3.Dot(ab0, cd0) == 1.0f;
        //bool isParallel = 1.0f - Mathf.Abs(Vector3.Dot(ab0, cd0)) < 0.0001f;
        if (isParallel) {
            Debug.Log("ab, cd平行");
            return;
        }

        // 是否在同一平面
        bool isPerp = Vector3.Dot(Vector3.Cross(ca, ab), cd) == 0.0f; // ca,ab 的叉积是否垂直于 cd
        //bool isPerp = Mathf.Abs(Vector3.Dot(Vector3.Cross(ca, ab), cd)) <= 0.0001f;// ca,ab 的叉积是否垂直于 cd
        if (!isPerp) {
            Debug.Log("ab, cd不在同一平面");
            return;
        }
        
        {// 以下 magnitude 为了计算更快可以使用 sqrMagnitude
            float af = Vector3.Cross(ca, cd0).magnitude;
            float eg = Vector3.Cross(ab, cd0).magnitude;

            float ao = af / eg * ab.magnitude;

            float t = ao / ab.magnitude;
            o.position = Vector3.LerpUnclamped(a.position, b.position, t);
        }*/
        
        
        

    }

}