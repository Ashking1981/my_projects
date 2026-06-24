/// What a player earns for completing a Level.
class RewardData {
  const RewardData({
    required this.xp,
    required this.coins,
    this.badgeId,
  });

  final int xp;
  final int coins;
  final String? badgeId;

  factory RewardData.fromJson(Map<String, dynamic> json) {
    return RewardData(
      xp: json['xp'] as int,
      coins: json['coins'] as int,
      badgeId: json['badgeId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'xp': xp,
        'coins': coins,
        if (badgeId != null) 'badgeId': badgeId,
      };
}
