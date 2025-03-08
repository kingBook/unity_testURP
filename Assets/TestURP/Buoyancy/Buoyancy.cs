using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Buoyancy : MonoBehaviour {

    public float p = 1000f;
    public float g = 9.81f;

    private Rigidbody m_rigidBody;

    private void Awake() {
        m_rigidBody = GetComponent<Rigidbody>();
    }

    public void FixedUpdate() {
        // 物体落水时减速
        Vector3 vel = m_rigidBody.velocity;
        vel.x = Mathf.Lerp(vel.x, 0f, 0.005f);
        vel.y = Mathf.Lerp(vel.y, 0f, 0.01f);
        vel.z = Mathf.Lerp(vel.z, 0f, 0.005f);
        m_rigidBody.velocity = vel;

        // F浮 = p液 * g * V排
        // p液：液体的密度，单位 kg/m^3
        // g：重力加速度，单位 m/s^2
        // V排：表示排开液体的体积，单位 m^3
       // float v = m_rigidBody
        //https://blog.csdn.net/weixin_43673589/article/details/123463124

        //Vector3 force = Vector3.zero;
        //force.y = p * g * v;
        //m_rigidBody.AddForce(force, ForceMode.Force);


    }
}