import 'package:flutter_test/flutter_test.dart';

import 'package:codeverse/data/models/challenge.dart';

void main() {
  test('MultipleChoiceChallenge grades by index', () {
    const challenge = MultipleChoiceChallenge(
      prompt: 'p',
      options: ['a', 'b', 'c'],
      correctIndex: 1,
    );
    expect(challenge.isCorrect(1), isTrue);
    expect(challenge.isCorrect(0), isFalse);
  });

  test('DragToOrderChallenge requires exact sequence', () {
    const challenge = DragToOrderChallenge(
      prompt: 'p',
      correctOrder: ['a', 'b', 'c'],
    );
    expect(challenge.isCorrect(['a', 'b', 'c']), isTrue);
    expect(challenge.isCorrect(['a', 'c', 'b']), isFalse);
    expect(challenge.isCorrect(['a', 'b']), isFalse);
  });

  test('FillBlankChallenge is case/whitespace insensitive', () {
    const challenge = FillBlankChallenge(
      prompt: 'p',
      template: 'x ___ y',
      answer: 'Hello',
    );
    expect(challenge.isCorrect('  hello  '), isTrue);
    expect(challenge.isCorrect('world'), isFalse);
  });

  test('MatchPairsChallenge requires every pair to match', () {
    const challenge = MatchPairsChallenge(
      prompt: 'p',
      pairs: {'Red': 'Warm', 'Blue': 'Cool'},
    );
    expect(challenge.isCorrect({'Red': 'Warm', 'Blue': 'Cool'}), isTrue);
    expect(challenge.isCorrect({'Red': 'Cool', 'Blue': 'Cool'}), isFalse);
  });

  test('BlockCodeChallenge requires exact block order', () {
    const challenge = BlockCodeChallenge(
      prompt: 'p',
      correctBlocks: ['def f():', '    pass'],
    );
    expect(challenge.isCorrect(['def f():', '    pass']), isTrue);
    expect(challenge.isCorrect(['    pass', 'def f():']), isFalse);
  });

  test('Challenge.fromJson dispatches by type', () {
    final json = {
      'type': 'multiple_choice',
      'prompt': 'p',
      'options': ['a', 'b'],
      'correctIndex': 0,
    };
    final challenge = Challenge.fromJson(json);
    expect(challenge, isA<MultipleChoiceChallenge>());
  });

  test('Challenge.fromJson throws on unknown type', () {
    expect(
      () => Challenge.fromJson({'type': 'unknown', 'prompt': 'p'}),
      throwsFormatException,
    );
  });
}
