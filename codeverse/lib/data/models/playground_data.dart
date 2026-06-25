/// Describes the hands-on sandbox shown between the Concept Card and the
/// Challenge. [config] is intentionally a loose bag of variant-specific
/// values (e.g. starter code, palette options) so new playground types can
/// be added as content without a code change to this model.
class PlaygroundData {
  const PlaygroundData({
    required this.type,
    required this.instructions,
    this.config = const {},
  });

  final String type;
  final String instructions;
  final Map<String, dynamic> config;

  factory PlaygroundData.fromJson(Map<String, dynamic> json) {
    return PlaygroundData(
      type: json['type'] as String,
      instructions: json['instructions'] as String,
      config: (json['config'] as Map<String, dynamic>?) ?? const {},
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'instructions': instructions,
        if (config.isNotEmpty) 'config': config,
      };
}
