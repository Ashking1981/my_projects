/// The scannable theory summary shown right after the Story Scene.
class ConceptData {
  const ConceptData({
    required this.title,
    required this.explanation,
    this.example,
  });

  final String title;
  final String explanation;
  final String? example;

  factory ConceptData.fromJson(Map<String, dynamic> json) {
    return ConceptData(
      title: json['title'] as String,
      explanation: json['explanation'] as String,
      example: json['example'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'explanation': explanation,
        if (example != null) 'example': example,
      };
}
