using UnityEngine;


public class BoxInstancing : MonoBehaviour {

    public int instanceCount = 20;
    public Mesh instanceMesh;
    public Material instanceMaterial;
    public int subMeshIndex;

    private ComputeBuffer m_argsBuffer;
    private readonly uint[] m_args = new uint[5] { 0, 0, 0, 0, 0 };

    private ComputeBuffer m_transformBuffer;
    private ComputeBuffer m_colorBuffer;
    private static readonly int s_transformBuffer = Shader.PropertyToID("transformBuffer");
    private static readonly int s_colorBuffer = Shader.PropertyToID("colorBuffer");

    private void Start() {
        m_argsBuffer = new ComputeBuffer(1, m_args.Length * sizeof(uint), ComputeBufferType.IndirectArguments);
        UpdateBuffers();
    }

    private void Update() {
        Graphics.DrawMeshInstancedIndirect(instanceMesh, subMeshIndex, instanceMaterial, new Bounds(Vector3.zero, new Vector3(100.0f, 100.0f, 100.0f)), m_argsBuffer);
    }

    private void UpdateBuffers() {
        // Positions and colors
        m_transformBuffer?.Release();
        m_transformBuffer = new ComputeBuffer(instanceCount, 64);
        m_colorBuffer?.Release();
        m_colorBuffer = new ComputeBuffer(instanceCount, 16);
        Matrix4x4[] matrixs = new Matrix4x4[instanceCount];
        Color[] colors = new Color[instanceCount];
        for (int i = 0; i < instanceCount; i++) {

            matrixs[i] = Matrix4x4.TRS(new Vector3(Random.Range(-10, 10), 0f, Random.Range(-10, 10)), Random.rotation, Vector3.one);
            colors[i] = Random.ColorHSV();
        }
        m_transformBuffer.SetData(matrixs);
        m_colorBuffer.SetData(colors);
        instanceMaterial.SetBuffer(s_transformBuffer, m_transformBuffer);
        instanceMaterial.SetBuffer(s_colorBuffer, m_colorBuffer);

        // Indirect args
        if (instanceMesh != null) {
            m_args[0] = (uint)instanceMesh.GetIndexCount(subMeshIndex);
            m_args[1] = (uint)instanceCount;
            m_args[2] = (uint)instanceMesh.GetIndexStart(subMeshIndex);
            m_args[3] = (uint)instanceMesh.GetBaseVertex(subMeshIndex);
        } else {
            m_args[0] = m_args[1] = m_args[2] = m_args[3] = 0;
        }
        m_argsBuffer.SetData(m_args);
    }

    private void OnDestroy() {
        m_argsBuffer?.Release();
        m_argsBuffer = null;

        m_transformBuffer?.Release();
        m_transformBuffer = null;

        m_colorBuffer?.Release();
        m_colorBuffer = null;
    }
}