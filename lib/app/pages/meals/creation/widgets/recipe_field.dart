import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeTextField extends ConsumerStatefulWidget {
  final StateProvider<String> provider;
  final String label;
  final TextInputType keyboardType;

  const RecipeTextField({
    required this.provider,
    required this.label,
    this.keyboardType = TextInputType.text,
    super.key,
  });

  @override
  _RecipeTextFieldState createState() => _RecipeTextFieldState();
}

class _RecipeTextFieldState extends ConsumerState<RecipeTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    if (text != ref.read(widget.provider)) {
      ref.read(widget.provider.notifier).state = text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(widget.provider);

    if (_controller.text != value) {
      _controller.text = value;
    }

    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(labelText: widget.label),
      keyboardType: widget.keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ${widget.label}';
        }
        return null;
      },
    );
  }
}
