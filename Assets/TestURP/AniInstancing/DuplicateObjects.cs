using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DuplicateObjects : MonoBehaviour {

    public GameObject womanPrefab;
    public int col = 50;
    public int row = 50;

    private void DuplicateObjs(GameObject prefab, int col, int row) {
        float space = 1;
        for (int i = 0; i < col; i++) {
            for (int j = 0; j < row; j++) {
                var inst = Instantiate(prefab, transform);
                inst.transform.position = new Vector3(i * space, 0, j * space);
            }
        }
    }

    private void Start() {
        Debug.Log($"count: {col * row}");
        DuplicateObjs(womanPrefab, col, row);
    }

    void Update() {

    }
}
