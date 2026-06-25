import '../../ui/tokens/app_colors.dart';
import 'challenge.dart';
import 'concept_data.dart';
import 'playground_data.dart';
import 'reward_data.dart';
import 'story_panel_data.dart';

/// One full pass through the core learning loop: Story Scene → Concept
/// Card → Interactive Playground → Challenge → Reward.
class Level {
  const Level({
    required this.id,
    required this.realmId,
    required this.order,
    required this.title,
    required this.isBoss,
    required this.story,
    required this.concept,
    required this.playground,
    required this.challenge,
    required this.reward,
  });

  final String id;
  final RealmId realmId;
  final int order;
  final String title;
  final bool isBoss;
  final List<StoryPanelData> story;
  final ConceptData concept;
  final PlaygroundData playground;
  final Challenge challenge;
  final RewardData reward;

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'] as String,
      realmId: RealmId.values.byName(json['realmId'] as String),
      order: json['order'] as int,
      title: json['title'] as String,
      isBoss: json['isBoss'] as bool? ?? false,
      story: (json['story'] as List)
          .map((e) => StoryPanelData.fromJson(e as Map<String, dynamic>))
          .toList(),
      concept: ConceptData.fromJson(json['concept'] as Map<String, dynamic>),
      playground:
          PlaygroundData.fromJson(json['playground'] as Map<String, dynamic>),
      challenge: Challenge.fromJson(json['challenge'] as Map<String, dynamic>),
      reward: RewardData.fromJson(json['reward'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'realmId': realmId.name,
        'order': order,
        'title': title,
        'isBoss': isBoss,
        'story': story.map((s) => s.toJson()).toList(),
        'concept': concept.toJson(),
        'playground': playground.toJson(),
        'challenge': challenge.toJson(),
        'reward': reward.toJson(),
      };
}
