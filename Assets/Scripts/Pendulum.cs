using UnityEngine;

public class Pendulum : MonoBehaviour
{
    public float length = 2.0f; // 单摆的长度
    public float gravity = 9.81f; // 重力加速度
    public float initialAngle = 45.0f; // 初始角度（以度为单位）

    private float angle; // 当前角度（以弧度为单位）
    private float angularVelocity; // 角速度

    void Start()
    {
        // 将初始角度转换为弧度
        angle = initialAngle * Mathf.Deg2Rad;
    }

    void FixedUpdate()
    {
        // 计算角加速度
        float angularAcceleration = (-gravity / length) * Mathf.Sin(angle);

        // 更新角速度
        angularVelocity += angularAcceleration * Time.fixedDeltaTime;

        // 更新角度
        angle += angularVelocity * Time.fixedDeltaTime;

        // 更新物体的位置
        transform.position = new Vector3(length * Mathf.Sin(angle), -length * Mathf.Cos(angle), 0);
    }
}