class Comment {
  final String id;
  final String sender;
  final String message;
  final String time;
  final bool isSentByMe;
  final String avatar;
  final Reply? replyTo;
  final String? additionalSender;
  final String? additionalMessage;
  final String questionId;

  Comment({
    required this.id,
    required this.sender,
    required this.message,
    required this.time,
    required this.isSentByMe,
    required this.avatar,
    this.replyTo,
    this.additionalSender,
    this.additionalMessage, 
    required this.questionId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      sender: json['sender'],
      message: json['message'],
      time: json['time'],
      isSentByMe: json['isSentByMe'],
      avatar: json['avatar'],
      replyTo: json['replyTo'] != null ? Reply.fromJson(json['replyTo']) : null,
      additionalSender: json['additionalSender'],
      additionalMessage: json['additionalMessage'], 
      questionId: json['questionId'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'message': message,
      'time': time,
      'isSentByMe': isSentByMe,
      'avatar': avatar,
      'replyTo': replyTo?.toJson(),
      'additionalSender': additionalSender,
      'additionalMessage': additionalMessage,
      'questionId': questionId,
    };
  }
}

class Reply {
  final String sender;
  final String message;

  Reply({
    required this.sender,
    required this.message,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      sender: json['sender'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'message': message,
    };
  }
}