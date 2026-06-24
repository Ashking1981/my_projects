/// One line of comic-style dialogue in a Level's Story Scene.
class StoryPanelData {
  const StoryPanelData({required this.speaker, required this.message});

  final String speaker;
  final String message;

  factory StoryPanelData.fromJson(Map<String, dynamic> json) {
    return StoryPanelData(
      speaker: json['speaker'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'speaker': speaker, 'message': message};
}
