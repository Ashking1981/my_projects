import '../../ui/tokens/app_colors.dart';

/// A learning world, e.g. "Python Peaks". Metadata only — its Levels are
/// loaded separately and linked by [Realm.id].
class Realm {
  const Realm({
    required this.id,
    required this.name,
    required this.mentorName,
    required this.description,
    required this.order,
  });

  final RealmId id;
  final String name;
  final String mentorName;
  final String description;
  final int order;

  factory Realm.fromJson(Map<String, dynamic> json) {
    return Realm(
      id: RealmId.values.byName(json['id'] as String),
      name: json['name'] as String,
      mentorName: json['mentorName'] as String,
      description: json['description'] as String,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.name,
        'name': name,
        'mentorName': mentorName,
        'description': description,
        'order': order,
      };
}
