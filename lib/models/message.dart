class Message {
 final String userId;
 final String text;
 final DateTime timestamp;

 Message({required this.userId, required this.text, required this.timestamp});

 Message.fromJson(Map<String, dynamic> json)
  : userId = json['userId'],
    text = json['text'],
    timestamp = DateTime.fromMicrosecondsSinceEpoch(json['timestamp']);

 Map<String, dynamic> toJson() =>
     {'userId': userId, 'text': text, 'timestamp': timestamp.microsecondsSinceEpoch};

 Message.fromMap(Map<String, dynamic> data)
  : userId = data['userId'],
    text = data['text'],
    timestamp = DateTime.fromMicrosecondsSinceEpoch(int.parse(data['timestamp']));
}