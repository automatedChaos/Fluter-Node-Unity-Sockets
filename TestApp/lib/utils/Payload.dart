class Payload {
  String action;
  String data;
  String key;
        
  Payload (this.action, this.data, this.key);

  Map toJson() => {
    'action': action,
    'data': data,
    'key': key
  };
}