import 'package:flutter/material.dart';
import 'package:laundry_hub/counter_logic.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final TextEditingController _controller = TextEditingController();
  int _counter = 0;
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final command = parseInput(_controller.text);

    switch (command) {
      case AddCommand(:final value):
        setState(() {
          _counter += value;
          _errorText = null;
        });
        _controller.clear();
      case ResetCommand():
        setState(() {
          _counter = 0;
          _errorText = null;
        });
        _controller.clear();
        _showMessage('Лічильник обнулено 🪄');
      case InvalidCommand(:final message):
        setState(() {
          _errorText = message;
        });
        _showMessage(message, isError: true);
    }
  }

  void _showMessage(String text, {bool isError = false}) {
    final colors = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: isError ? colors.error : null,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _clearErrorOnEdit(String _) {
    if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторна №1 — Лічильник'),
        backgroundColor: colors.primaryContainer,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Поточне значення',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '$_counter',
                      key: const Key('counterValue'),
                      style: textTheme.displayLarge?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    key: const Key('inputField'),
                    controller: _controller,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Число або команда',
                      hintText: 'Напр.: 5, -3 або $resetPhrase',
                      errorText: _errorText,
                      prefixIcon: const Icon(Icons.edit),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: _clearErrorOnEdit,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    key: const Key('applyButton'),
                    onPressed: _submit,
                    icon: const Icon(Icons.check),
                    label: const Text('Застосувати'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
