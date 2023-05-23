class Message {
 final String userId;
 final String text;
 final DateTime timestamp;

 Message({required this.userId, required this.text, required this.timestamp});

 Message.fromJson(Map<String, dynamic> json)
  : userId = json['userId'],
    text = json['text'],
    timestamp = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);

 Map<String, dynamic> toJson() =>
     {'userId': userId, 'text': text, 'timestamp': timestamp.millisecondsSinceEpoch};

 Message.fromMap(Map<String, dynamic> data)
  : userId = data['userId'],
    text = data['text'],
    timestamp = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
}