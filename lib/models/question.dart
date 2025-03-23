class Answer {
  final String id;
  final String text;
  final int likes;
  final int comments;
  final String timeAgo;

  Answer({
    required this.id,
    required this.text,
    required this.likes,
    required this.comments,
    required this.timeAgo,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      text: json['text'],
      likes: json['likes'],
      comments: json['comments'],
      timeAgo: json['timeAgo'],
    );
  }
}

class Question {
  final String id;
  final String courseId;
  final String text;
  final int likes;
  final int comments;
  final String timeAgo;
  final List<Answer> answers;
  bool isAnswerVisible;

  Question({
    required this.id,
    required this.courseId,
    required this.text,
    required this.likes,
    required this.comments,
    required this.timeAgo,
    required this.answers,
    this.isAnswerVisible = false,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    List<Answer> answersList = [];
    if (json['answers'] != null) {
      answersList = (json['answers'] as List)
          .map((answerJson) => Answer.fromJson(answerJson))
          .toList();
    }

    return Question(
      id: json['id'],
      courseId: json['courseId'],
      text: json['text'],
      likes: json['likes'],
      comments: json['comments'],
      timeAgo: json['timeAgo'],
      answers: answersList,
      isAnswerVisible: false,
    );
  }
}