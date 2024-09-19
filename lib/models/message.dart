class Message {
  Message({
    required this.toID,
    required this.msg,
    required this.read,
    required this.type,
    required this.sent,
    required this.fromID,
  });

  late final String toID;
  late final String msg;
  late final String read;
  late final String sent;
  late final String fromID;
  late final Type type;

  // Convert from JSON (from Firestore)
  Message.fromJson(Map<String, dynamic> json) {
    toID = json['toID'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    sent = json['sent'].toString();
    fromID = json['fromID'].toString();
    // Convert string to enum type
    type = json['type'] == 'image' ? Type.image : Type.text;
  }

  // Convert to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toID'] = toID;
    data['msg'] = msg;
    data['read'] = read;
    // Convert enum type to string
    data['type'] = type.name; // type.name converts enum to string
    data['sent'] = sent;
    data['fromID'] = fromID;
    return data;
  }
}

enum Type { text, image }
