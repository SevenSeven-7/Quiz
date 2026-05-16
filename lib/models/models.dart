enum QuestionType { mcq, essay }

class QuestionModel {
  final String id;
  final String text;
  final QuestionType type;
  final List<String>? options; // Digunakan untuk MCQ
  final int? correctAnswerIndex; // Digunakan untuk MCQ
  final String? correctAnswer; // Digunakan untuk Essay

  QuestionModel({
    required this.id,
    required this.text,
    required this.type,
    this.options,
    this.correctAnswerIndex,
    this.correctAnswer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      text: json['text'],
      type: json['type'] == 'essay' ? QuestionType.essay : QuestionType.mcq,
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      correctAnswerIndex: json['correctAnswerIndex'],
      correctAnswer: json['correctAnswer'],
    );
  }
}

class LevelModel {
  final String id;
  final int order;
  final String partId;
  final List<QuestionModel> questions;
  final int stars; // 0, 1, 2, 3
  final bool isUnlocked;

  LevelModel({
    required this.id,
    required this.order,
    required this.partId,
    required this.questions,
    this.stars = 0,
    this.isUnlocked = false,
  });
}

class PartModel {
  final String id;
  final String title;
  final String description;
  final bool isLocked;
  final double progress; // 0.0 to 1.0

  PartModel({
    required this.id,
    required this.title,
    required this.description,
    this.isLocked = false,
    this.progress = 0.0,
  });
}

class UserModel {
  final String uid;
  final String username;
  final int totalScore;
  final DateTime joinDate;

  UserModel({
    required this.uid,
    required this.username,
    required this.totalScore,
    required this.joinDate,
  });

  factory UserModel.initial() {
    return UserModel(
      uid: 'guest',
      username: 'Pemain',
      totalScore: 0,
      joinDate: DateTime.now(),
    );
  }
}
