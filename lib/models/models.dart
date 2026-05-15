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

class CategoryModel {
  final String id;
  final String name;
  final String icon;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class QuestionModel {
  final String id;
  final String categoryId;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;

  QuestionModel({
    required this.id,
    required this.categoryId,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
  });
}
