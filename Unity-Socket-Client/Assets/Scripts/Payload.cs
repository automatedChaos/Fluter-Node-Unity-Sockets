using UnityEngine;

public class Payload 
{
    public string key;
    public string action;
    public string data;
  
    Payload (string key, string action, string data){
        this.key = key;
        this.action = action;
        this.data = data;
    }

    public Vector3 getDataAsVector3() {

        Vector3 vectorData = new Vector3(0, 0, 0);

        string[] values = this.data.Split(',');
        
        if (values.Length > 0){

            vectorData = new Vector3(float.Parse(values[0]), float.Parse(values[1]), 0);
        }

        return vectorData;
    }
}