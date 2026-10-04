import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/parent_gate.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../state/providers.dart';
import '../../theme.dart';

/// A times-table question with a number pad. A wrong answer just shows a new
/// question; there is no lockout.
class GateScreen extends ConsumerStatefulWidget {
  const GateScreen({super.key});

  @override
  ConsumerState<GateScreen> createState() => _GateScreenState();
}

class _GateScreenState extends ConsumerState<GateScreen> {
  final _rng = Random();
  late GateQuestion _question = GateQuestion.random(_rng);
  String _entry = '';
  bool _wrong = false;

  void _digit(int d) {
    if (_entry.length >= 3) return;
    setState(() {
      _entry += '$d';
      _wrong = false;
    });
  }

  void _backspace() {
    if (_entry.isEmpty) return;
    setState(() => _entry = _entry.substring(0, _entry.length - 1));
  }

  void _submit() {
    if (_entry.isEmpty) return;
    if (_question.check(int.parse(_entry))) {
      ref.read(parentSessionProvider.notifier).unlock();
      context.go('/parent');
    } else {
      setState(() {
        _question = GateQuestion.random(_rng, notLike: _question);
        _entry = '';
        _wrong = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.gateTitle),
        backgroundColor: AppColors.background,
        leading: IconButton(
          tooltip: l.cancel,
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Padding(
                padding: const EdgeInsetsDirectional.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Math reads left-to-right in every language.
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        l.gateQuestion(_question.a, _question.b),
                        style: t.displaySmall,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 160,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _entry,
                        style: t.displaySmall,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                      child: _wrong
                          ? Center(
                              child: Text(l.gateTryAgain, style: t.bodyMedium),
                            )
                          : null,
                    ),
                    _NumberPad(
                      onDigit: _digit,
                      onBackspace: _backspace,
                      onSubmit: _submit,
                      backspaceLabel: l.gateBackspace,
                      submitLabel: l.gateConfirm,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberPad extends StatelessWidget {
  const _NumberPad({
    required this.onDigit,
    required this.onBackspace,
    required this.onSubmit,
    required this.backspaceLabel,
    required this.submitLabel,
  });

  final ValueChanged<int> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onSubmit;
  final String backspaceLabel;
  final String submitLabel;

  @override
  Widget build(BuildContext context) {
    Widget key(
      Widget child,
      VoidCallback onTap, {
      String? label,
      Color? color,
    }) => Padding(
      padding: const EdgeInsets.all(6),
      child: SizedBox(
        width: 84,
        height: 64,
        child: Semantics(
          label: label,
          button: true,
          excludeSemantics: label != null,
          child: FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: color ?? AppColors.surface,
              foregroundColor: AppColors.ink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: onTap,
            child: child,
          ),
        ),
      ),
    );

    // Phone keypad layout, the same in every language.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          for (final row in const [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
          ])
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final d in row) key(Text('$d'), () => onDigit(d)),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              key(
                const Icon(Icons.backspace_outlined),
                onBackspace,
                label: backspaceLabel,
              ),
              key(const Text('0'), () => onDigit(0)),
              key(
                const Icon(Icons.check_rounded, color: Colors.white),
                onSubmit,
                label: submitLabel,
                color: AppColors.done,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
