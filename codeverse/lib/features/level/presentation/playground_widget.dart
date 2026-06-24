import 'package:flutter/material.dart';

import '../../../data/models/playground_data.dart';
import '../../../ui/ui.dart';

/// A real (if lightweight) hands-on sandbox for the concept just taught.
/// Purely exploratory — nothing here is graded, that's the Challenge's job.
/// Dispatches on [PlaygroundData.type] using only the JSON `config`, so a
/// new playground variant is still a content + this-file change, never a
/// change to the Level/Realm data models.
class PlaygroundWidget extends StatefulWidget {
  const PlaygroundWidget({super.key, required this.playground});

  final PlaygroundData playground;

  @override
  State<PlaygroundWidget> createState() => _PlaygroundWidgetState();
}

class _PlaygroundWidgetState extends State<PlaygroundWidget> {
  @override
  Widget build(BuildContext context) {
    final config = widget.playground.config;
    return switch (widget.playground.type) {
      'code_fill' => _CodeFillPlayground(starterCode: config['starterCode'] as String? ?? ''),
      'data_collector' => _DataCollectorPlayground(
          categories: (config['categories'] as List?)?.cast<String>() ?? const [],
        ),
      'sorting_sandbox' => _SortingSandboxPlayground(
          numbers: (config['numbers'] as List?)?.cast<int>() ?? const [],
        ),
      'average_calculator' => _AverageCalculatorPlayground(
          startingNumbers:
              (config['startingNumbers'] as List?)?.cast<int>() ?? const [],
        ),
      'sequence_builder' => _SequenceBuilderPlayground(
          steps: (config['steps'] as List?)?.cast<String>() ?? const [],
        ),
      'coordinate_mover' => _CoordinateMoverPlayground(
          gridSize: config['gridSize'] as int? ?? 5,
        ),
      'collision_sandbox' => const _CollisionSandboxPlayground(),
      'pattern_spotter' => _PatternSpotterPlayground(
          examples: (config['examples'] as List?)?.cast<String>() ?? const [],
        ),
      'sequence_predictor' => _SequencePredictorPlayground(
          sequence: (config['sequence'] as List?)?.cast<String>() ?? const [],
        ),
      'classifier_sandbox' => _ClassifierSandboxPlayground(
          groups: (config['groups'] as List?)?.cast<String>() ?? const [],
        ),
      'color_picker' => _ColorPickerPlayground(
          palette: (config['palette'] as List?)?.cast<String>() ?? const [],
        ),
      'shape_sorter' => _ShapeSorterPlayground(
          shapes: (config['shapes'] as List?)?.cast<String>() ?? const [],
        ),
      'layout_grid' => _LayoutGridPlayground(
          cardCount: config['cardCount'] as int? ?? 4,
        ),
      _ => Center(
          child: Text(
            widget.playground.instructions,
            textAlign: TextAlign.center,
          ),
        ),
    };
  }
}

class _PlaygroundScaffold extends StatelessWidget {
  const _PlaygroundScaffold({required this.instructions, required this.child});

  final String? instructions;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (instructions != null && instructions!.isNotEmpty) ...[
          Text(instructions!, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
        ],
        Expanded(child: child),
      ],
    );
  }
}

class _CodeFillPlayground extends StatefulWidget {
  const _CodeFillPlayground({required this.starterCode});

  final String starterCode;

  @override
  State<_CodeFillPlayground> createState() => _CodeFillPlaygroundState();
}

class _CodeFillPlaygroundState extends State<_CodeFillPlayground> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.starterCode);
  String? _output;

  void _run() {
    setState(() {
      _output = _controller.text.trim().isEmpty
          ? '(nothing to run)'
          : 'Ran ${_controller.text.trim().split('\n').length} line(s) — '
              'looks good!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return _PlaygroundScaffold(
      instructions: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1B2E),
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(label: 'Run', icon: Icons.play_arrow_rounded, onPressed: _run),
          if (_output != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(_output!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _DataCollectorPlayground extends StatefulWidget {
  const _DataCollectorPlayground({required this.categories});

  final List<String> categories;

  @override
  State<_DataCollectorPlayground> createState() =>
      _DataCollectorPlaygroundState();
}

class _DataCollectorPlaygroundState extends State<_DataCollectorPlayground> {
  late final Map<String, int> _tally = {for (final c in widget.categories) c: 0};

  @override
  Widget build(BuildContext context) {
    return _PlaygroundScaffold(
      instructions: 'Tap a category each time you see one.',
      child: ListView(
        children: [
          for (final category in widget.categories)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(child: Text(category)),
                  Text('${_tally[category]}'),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setState(() => _tally[category] = _tally[category]! + 1),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SortingSandboxPlayground extends StatefulWidget {
  const _SortingSandboxPlayground({required this.numbers});

  final List<int> numbers;

  @override
  State<_SortingSandboxPlayground> createState() =>
      _SortingSandboxPlaygroundState();
}

class _SortingSandboxPlaygroundState extends State<_SortingSandboxPlayground> {
  late final List<int> _numbers = [...widget.numbers];

  @override
  Widget build(BuildContext context) {
    return _PlaygroundScaffold(
      instructions: 'Tap "Sort" and watch the numbers fall into order.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final n in _numbers)
                CircleAvatar(child: Text('$n')),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: 'Sort',
            icon: Icons.sort_rounded,
            onPressed: () => setState(() => _numbers.sort()),
          ),
        ],
      ),
    );
  }
}

class _AverageCalculatorPlayground extends StatefulWidget {
  const _AverageCalculatorPlayground({required this.startingNumbers});

  final List<int> startingNumbers;

  @override
  State<_AverageCalculatorPlayground> createState() =>
      _AverageCalculatorPlaygroundState();
}

class _AverageCalculatorPlaygroundState
    extends State<_AverageCalculatorPlayground> {
  late final List<int> _numbers = [...widget.startingNumbers];

  double get _average =>
      _numbers.isEmpty ? 0 : _numbers.reduce((a, b) => a + b) / _numbers.length;

  @override
  Widget build(BuildContext context) {
    return _PlaygroundScaffold(
      instructions: 'Add or remove numbers and watch the average update.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final n in _numbers)
                Chip(
                  label: Text('$n'),
                  onDeleted: () => setState(() => _numbers.remove(n)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
            label: 'Add 5',
            icon: Icons.add_rounded,
            onPressed: () => setState(() => _numbers.add(5)),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Average: ${_average.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _SequenceBuilderPlayground extends StatefulWidget {
  const _SequenceBuilderPlayground({required this.steps});

  final List<String> steps;

  @override
  State<_SequenceBuilderPlayground> createState() =>
      _SequenceBuilderPlaygroundState();
}

class _SequenceBuilderPlaygroundState
    extends State<_SequenceBuilderPlayground> {
  late final List<String> _order = [...widget.steps]..shuffle();

  void _moveUp(int index) {
    if (index == 0) return;
    setState(() {
      final item = _order.removeAt(index);
      _order.insert(index - 1, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _PlaygroundScaffold(
      instructions: 'Use the arrows to put the steps in the order they run.',
      child: ListView(
        children: [
          for (var i = 0; i < _order.length; i++)
            ListTile(
              leading: IconButton(
                icon: const Icon(Icons.arrow_upward_rounded),
                onPressed: () => _moveUp(i),
              ),
              title: Text(_order[i]),
            ),
        ],
      ),
    );
  }
}

class _CoordinateMoverPlayground extends StatefulWidget {
  const _CoordinateMoverPlayground({required this.gridSize});

  final int gridSize;

  @override
  State<_CoordinateMoverPlayground> createState() =>
      _CoordinateMoverPlaygroundState();
}

class _CoordinateMoverPlaygroundState
    extends State<_CoordinateMoverPlayground> {
  int _x = 0;
  int _y = 0;

  @override
  Widget build(BuildContext context) {
    return _PlaygroundScaffold(
      instructions: 'Tap a cell to move the marker there.',
      child: Column(
        children: [
          Text('Position: ($_x, $_y)'),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.gridSize,
              ),
              itemCount: widget.gridSize * widget.gridSize,
              itemBuilder: (context, index) {
                final x = index % widget.gridSize;
                final y = index ~/ widget.gridSize;
                final isMarker = x == _x && y == _y;
                return GestureDetector(
                  onTap: () => setState(() {
                    _x = x;
                    _y = y;
                  }),
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    color: isMarker
                        ? AppColors.brandPrimary
                        : Colors.grey.shade200,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CollisionSandboxPlayground extends StatefulWidget {
  const _CollisionSandboxPlayground();

  @override
  State<_CollisionSandboxPlayground> createState() =>
      _CollisionSandboxPlaygroundState();
}

class _CollisionSandboxPlaygroundState
    extends State<_CollisionSandboxPlayground> {
  Offset _position = const Offset(20, 20);
  static const Offset _targetCenter = Offset(150, 150);
  static const double _hitDistance = 40;

  bool get _colliding => (_position - _targetCenter).distance < _hitDistance;

  @override
  Widget build(BuildContext context) {
    return _PlaygroundScaffold(
      instructions: 'Drag the circle into the target to trigger a collision.',
      child: Stack(
        children: [
          Positioned(
            left: _targetCenter.dx - 30,
            top: _targetCenter.dy - 30,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _colliding
                    ? AppColors.success
                    : AppColors.brandSecondary.withOpacity(0.4),
              ),
            ),
          ),
          Positioned(
            left: _position.dx - 20,
            top: _position.dy - 20,
            child: GestureDetector(
              onPanUpdate: (details) =>
                  setState(() => _position += details.delta),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.brandPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PatternSpotterPlayground extends StatefulWidget {
  const _PatternSpotterPlayground({required this.examples});

  final List<String> examples;

  @override
  State<_PatternSpotterPlayground> createState() =>
      _PatternSpotterPlaygroundState();
}

class _PatternSpotterPlaygroundState
    extends State<_PatternSpotterPlayground> {
  final Set<int> _revealed = {};

  @override
  Widget build(BuildContext context) {
    return _PlaygroundScaffold(
      instructions: 'Tap each example to study it.',
      child: ListView(
        children: [
          for (var i = 0; i < widget.examples.length; i++)
            Card(
              child: ListTile(
                title: Text(widget.examples[i]),
                trailing: Icon(
                  _revealed.contains(i)
                      ? Icons.lightbulb_rounded
                      : Icons.lightbulb_outline_rounded,
                ),
                onTap: () => setState(() => _revealed.add(i)),
              ),
            ),
        ],
      ),
    );
  }
}

class _SequencePredictorPlayground extends StatefulWidget {
  const _SequencePredictorPlayground({required this.sequence});

  final List<String> sequence;

  @override
  State<_SequencePredictorPlayground> createState() =>
      _SequencePredictorPlaygroundState();
}

class _SequencePredictorPlaygroundState
    extends State<_SequencePredictorPlayground> {
  String? _guess;

  @override
  Widget build(BuildContext context) {
    final unique = widget.sequence.toSet().toList();
    return _PlaygroundScaffold(
      instructions: 'What comes next in this sequence?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            children: [for (final s in widget.sequence) Chip(label: Text(s))],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final option in unique)
                ChoiceChip(
                  label: Text(option),
                  selected: _guess == option,
                  onSelected: (_) => setState(() => _guess = option),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClassifierSandboxPlayground extends StatefulWidget {
  const _ClassifierSandboxPlayground({required this.groups});

  final List<String> groups;

  @override
  State<_ClassifierSandboxPlayground> createState() =>
      _ClassifierSandboxPlaygroundState();
}

class _ClassifierSandboxPlaygroundState
    extends State<_ClassifierSandboxPlayground> {
  String? _selectedGroup;

  @override
  Widget build(BuildContext context) {
    return _PlaygroundScaffold(
      instructions: 'Pick a group, then tap to file this example into it.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final group in widget.groups)
                ChoiceChip(
                  label: Text(group),
                  selected: _selectedGroup == group,
                  onSelected: (_) => setState(() => _selectedGroup = group),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (_selectedGroup != null)
            Text('Filed under: $_selectedGroup'),
        ],
      ),
    );
  }
}

class _ColorPickerPlayground extends StatefulWidget {
  const _ColorPickerPlayground({required this.palette});

  final List<String> palette;

  @override
  State<_ColorPickerPlayground> createState() =>
      _ColorPickerPlaygroundState();
}

class _ColorPickerPlaygroundState extends State<_ColorPickerPlayground> {
  Color? _selected;

  static Color _parseHex(String hex) =>
      Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));

  @override
  Widget build(BuildContext context) {
    return _PlaygroundScaffold(
      instructions: 'Tap a swatch to preview it.',
      child: Column(
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final hex in widget.palette)
                GestureDetector(
                  onTap: () => setState(() => _selected = _parseHex(hex)),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _parseHex(hex),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_selected != null)
            Container(width: 80, height: 80, color: _selected),
        ],
      ),
    );
  }
}

class _ShapeSorterPlayground extends StatefulWidget {
  const _ShapeSorterPlayground({required this.shapes});

  final List<String> shapes;

  @override
  State<_ShapeSorterPlayground> createState() =>
      _ShapeSorterPlaygroundState();
}

class _ShapeSorterPlaygroundState extends State<_ShapeSorterPlayground> {
  static const Map<String, IconData> _icons = {
    'circle': Icons.circle,
    'square': Icons.square,
    'triangle': Icons.change_history_rounded,
  };

  final List<String> _bin = [];

  @override
  Widget build(BuildContext context) {
    return _PlaygroundScaffold(
      instructions: 'Tap each shape to sort it into the bin.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final shape in widget.shapes)
                IconButton(
                  icon: Icon(_icons[shape] ?? Icons.help_outline),
                  onPressed: () => setState(() => _bin.add(shape)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Bin: ${_bin.join(', ')}'),
        ],
      ),
    );
  }
}

class _LayoutGridPlayground extends StatefulWidget {
  const _LayoutGridPlayground({required this.cardCount});

  final int cardCount;

  @override
  State<_LayoutGridPlayground> createState() => _LayoutGridPlaygroundState();
}

class _LayoutGridPlaygroundState extends State<_LayoutGridPlayground> {
  int _columns = 2;

  @override
  Widget build(BuildContext context) {
    return _PlaygroundScaffold(
      instructions: 'Try different column counts for this layout.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Slider(
            value: _columns.toDouble(),
            min: 1,
            max: 4,
            divisions: 3,
            label: '$_columns columns',
            onChanged: (value) => setState(() => _columns = value.round()),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _columns,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
              ),
              itemCount: widget.cardCount,
              itemBuilder: (context, index) => Card(
                child: Center(child: Text('${index + 1}')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
