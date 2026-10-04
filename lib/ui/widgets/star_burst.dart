import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// A big star that pops in while small stars fly outward. Plays once on
/// creation and calls [onDone]. Stays within the 1.5 s animation budget.
class StarBurst extends StatefulWidget {
  const StarBurst({super.key, this.size = 220, this.onDone});

  static const duration = Duration(milliseconds: 1200);

  final double size;
  final VoidCallback? onDone;

  @override
  State<StarBurst> createState() => _StarBurstState();
}

class _StarBurstState extends State<StarBurst>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: StarBurst.duration)
    ..forward().whenComplete(() => widget.onDone?.call());

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pop = CurvedAnimation(
      parent: _c,
      curve: const Interval(0, 0.45, curve: Curves.elasticOut),
    );
    final fade = CurvedAnimation(parent: _c, curve: const Interval(0.75, 1));
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Opacity(
          opacity: 1 - fade.value,
          child: SizedBox.square(
            dimension: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                for (var i = 0; i < 8; i++)
                  Transform.translate(
                    offset: Offset.fromDirection(
                      i * math.pi / 4,
                      widget.size * 0.42 * Curves.easeOut.transform(_c.value),
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      size: widget.size * 0.14,
                      color: AppColors.star,
                    ),
                  ),
                Transform.scale(
                  scale: pop.value,
                  child: Icon(
                    Icons.star_rounded,
                    size: widget.size * 0.6,
                    color: AppColors.star,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
