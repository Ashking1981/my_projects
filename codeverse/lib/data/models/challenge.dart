/// The graded task at the end of a Level. Each subtype owns its own
/// grading logic so the Challenge engine (Phase 5) can stay generic:
/// `challenge.isCorrect(response)`.
sealed class Challenge {
  const Challenge({required this.prompt});

  final String prompt;

  String get type;

  /// [response] shape depends on the subtype — see each grade() override.
  bool isCorrect(Object? response);

  Map<String, dynamic> toJson();

  factory Challenge.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'multiple_choice':
        return MultipleChoiceChallenge.fromJson(json);
      case 'drag_to_order':
        return DragToOrderChallenge.fromJson(json);
      case 'fill_blank':
        return FillBlankChallenge.fromJson(json);
      case 'match_pairs':
        return MatchPairsChallenge.fromJson(json);
      case 'block_code':
        return BlockCodeChallenge.fromJson(json);
      default:
        throw FormatException('Unknown challenge type: $type');
    }
  }
}

class MultipleChoiceChallenge extends Challenge {
  const MultipleChoiceChallenge({
    required super.prompt,
    required this.options,
    required this.correctIndex,
  });

  final List<String> options;
  final int correctIndex;

  @override
  String get type => 'multiple_choice';

  /// [response] is the selected option index.
  @override
  bool isCorrect(Object? response) => response == correctIndex;

  factory MultipleChoiceChallenge.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceChallenge(
      prompt: json['prompt'] as String,
      options: (json['options'] as List).cast<String>(),
      correctIndex: json['correctIndex'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'prompt': prompt,
        'options': options,
        'correctIndex': correctIndex,
      };
}

class DragToOrderChallenge extends Challenge {
  const DragToOrderChallenge({
    required super.prompt,
    required this.correctOrder,
  });

  /// The items in their correct sequence; the UI shuffles them for display.
  final List<String> correctOrder;

  @override
  String get type => 'drag_to_order';

  /// [response] is the player's ordering of the same items.
  @override
  bool isCorrect(Object? response) {
    if (response is! List<String>) return false;
    if (response.length != correctOrder.length) return false;
    for (var i = 0; i < correctOrder.length; i++) {
      if (response[i] != correctOrder[i]) return false;
    }
    return true;
  }

  factory DragToOrderChallenge.fromJson(Map<String, dynamic> json) {
    return DragToOrderChallenge(
      prompt: json['prompt'] as String,
      correctOrder: (json['correctOrder'] as List).cast<String>(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'prompt': prompt,
        'correctOrder': correctOrder,
      };
}

class FillBlankChallenge extends Challenge {
  const FillBlankChallenge({
    required super.prompt,
    required this.template,
    required this.answer,
  });

  /// Contains a single `___` placeholder for the blank.
  final String template;
  final String answer;

  @override
  String get type => 'fill_blank';

  /// [response] is the player's typed answer; matched case-insensitively
  /// with surrounding whitespace trimmed.
  @override
  bool isCorrect(Object? response) {
    if (response is! String) return false;
    return response.trim().toLowerCase() == answer.trim().toLowerCase();
  }

  factory FillBlankChallenge.fromJson(Map<String, dynamic> json) {
    return FillBlankChallenge(
      prompt: json['prompt'] as String,
      template: json['template'] as String,
      answer: json['answer'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'prompt': prompt,
        'template': template,
        'answer': answer,
      };
}

class MatchPairsChallenge extends Challenge {
  const MatchPairsChallenge({required super.prompt, required this.pairs});

  final Map<String, String> pairs;

  @override
  String get type => 'match_pairs';

  /// [response] is the player's proposed left→right mapping.
  @override
  bool isCorrect(Object? response) {
    if (response is! Map<String, String>) return false;
    if (response.length != pairs.length) return false;
    for (final entry in pairs.entries) {
      if (response[entry.key] != entry.value) return false;
    }
    return true;
  }

  factory MatchPairsChallenge.fromJson(Map<String, dynamic> json) {
    return MatchPairsChallenge(
      prompt: json['prompt'] as String,
      pairs: (json['pairs'] as Map<String, dynamic>).cast<String, String>(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'prompt': prompt,
        'pairs': pairs,
      };
}

class BlockCodeChallenge extends Challenge {
  const BlockCodeChallenge({
    required super.prompt,
    required this.correctBlocks,
    this.distractorBlocks = const [],
  });

  /// Code blocks in their correct snap order.
  final List<String> correctBlocks;

  /// Extra wrong blocks shown alongside the correct ones to raise difficulty.
  final List<String> distractorBlocks;

  @override
  String get type => 'block_code';

  /// [response] is the player's assembled block sequence.
  @override
  bool isCorrect(Object? response) {
    if (response is! List<String>) return false;
    if (response.length != correctBlocks.length) return false;
    for (var i = 0; i < correctBlocks.length; i++) {
      if (response[i] != correctBlocks[i]) return false;
    }
    return true;
  }

  factory BlockCodeChallenge.fromJson(Map<String, dynamic> json) {
    return BlockCodeChallenge(
      prompt: json['prompt'] as String,
      correctBlocks: (json['correctBlocks'] as List).cast<String>(),
      distractorBlocks:
          (json['distractorBlocks'] as List?)?.cast<String>() ?? const [],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'prompt': prompt,
        'correctBlocks': correctBlocks,
        if (distractorBlocks.isNotEmpty) 'distractorBlocks': distractorBlocks,
      };
}
