import 'package:flutter/material.dart';

import '../theme.dart';

/// Plain Material scaffold for parent-mode screens.
class ParentScaffold extends StatelessWidget {
  const ParentScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.leading,
    this.floatingActionButton,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.background,
        leading: leading,
        actions: actions,
      ),
      floatingActionButton: floatingActionButton,
      body: SafeArea(top: false, child: body),
    );
  }
}

Future<bool> confirm(
  BuildContext context, {
  required String title,
  String? body,
  required String confirmLabel,
  required String cancelLabel,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: body == null ? null : Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return ok ?? false;
}
