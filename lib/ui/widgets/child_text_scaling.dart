import 'package:flutter/widgets.dart';

/// Child screens use very large type already (task name 36 px, Done 30 px),
/// so system text scaling is capped at 1.5x there: still far above 200% of
/// body text, and it keeps the picture, timer and Done button on screen.
/// (Android's own nonlinear font scaling also grows large text less.)
Widget childTextScaling(BuildContext context, Widget child) =>
    MediaQuery.withClampedTextScaling(maxScaleFactor: 1.5, child: child);
