class KataMotivasiFormModel {
  final String text;
  final String author;

  KataMotivasiFormModel({
    required this.text,
    required this.author,
  });

  factory KataMotivasiFormModel.fromJson(Map<String, dynamic> json) {
    return KataMotivasiFormModel(
      text: json['text'] ?? '',
      author: json['author'] ?? '',
    );
  }

  bool isValid() {
    return text.isNotEmpty && author.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author,
    };
  }
}
