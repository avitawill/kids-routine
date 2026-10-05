import 'dart:async';

import 'package:flutter/material.dart';

import '../../../domain/parent_gate.dart';
import '../../theme.dart';

/// The parent entry: a small gear that only opens when held for
/// [gateHoldDuration]. A ring fills while holding; a quick tap shows a hint
/// instead of doing nothing (which looked broken).
///
/// The hold is timed by the clock, not by animation frames, so it works even
/// when the app drops frames (e.g. right after launch).
class GearHoldButton extends StatefulWidget {
  const GearHoldButton({
    super.key,
    required this.tooltip,
    required this.onHeld,
  });

  final String tooltip;
  final VoidCallback onHeld;

  @override
  State<GearHoldButton> createState() => _GearHoldButtonState();
}

class _GearHoldButtonState extends State<GearHoldButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ring;
  final _hint = GlobalKey<TooltipState>();
  Timer? _hold;

  @override
  void initState() {
    super.initState();
    _ring = AnimationController(vsync: this, duration: gateHoldDuration);
  }

  @override
  void dispose() {
    _hold?.cancel();
    _ring.dispose();
    super.dispose();
  }

  void _down() {
    _hold?.cancel();
    _ring.forward(from: 0);
    _hold = Timer(gateHoldDuration, () {
      _hold = null;
      _ring.reset();
      widget.onHeld();
    });
  }

  void _up() {
    final wasHolding = _hold != null;
    _hold?.cancel();
    _hold = null;
    _ring.reset();
    // Let go too early: explain instead of silently ignoring the tap.
    if (wasHolding) _hint.currentState?.ensureTooltipVisible();
  }

  void _cancel() {
    _hold?.cancel();
    _hold = null;
    _ring.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: _hint,
      message: widget.tooltip,
      triggerMode: TooltipTriggerMode.manual,
      showDuration: const Duration(seconds: 3),
      child: Semantics(
        button: true,
        label: widget.tooltip,
        // Screen readers can't "hold"; their long-press action still opens it.
        onLongPress: widget.onHeld,
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (_) => _down(),
          onPointerUp: (_) => _up(),
          onPointerCancel: (_) => _cancel(),
          child: SizedBox.square(
            dimension: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _ring,
                  builder: (context, _) => _ring.value == 0
                      ? const SizedBox.shrink()
                      : SizedBox.square(
                          dimension: 42,
                          child: CircularProgressIndicator(
                            value: _ring.value,
                            strokeWidth: 3,
                            color: AppColors.primary,
                          ),
                        ),
                ),
                const Icon(
                  Icons.settings_rounded,
                  color: AppColors.inkSoft,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
