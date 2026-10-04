import 'package:flutter/material.dart';

import '../../../domain/parent_gate.dart';
import '../../theme.dart';

/// The parent entry: a small gear that only opens when held for
/// [gateHoldDuration]. A ring fills while holding; a quick tap does nothing.
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
  late final AnimationController _hold =
      AnimationController(vsync: this, duration: gateHoldDuration)
        ..addStatusListener((s) {
          if (s == AnimationStatus.completed) {
            _hold.reset();
            widget.onHeld();
          }
        });

  @override
  void dispose() {
    _hold.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      triggerMode: TooltipTriggerMode.manual,
      child: Semantics(
        button: true,
        label: widget.tooltip,
        // Screen readers can't "hold"; their long-press action still opens it.
        onLongPress: widget.onHeld,
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (_) => _hold.forward(from: 0),
          onPointerUp: (_) => _hold.reset(),
          onPointerCancel: (_) => _hold.reset(),
          child: SizedBox.square(
            dimension: 52,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _hold,
                  builder: (context, _) => _hold.value == 0
                      ? const SizedBox.shrink()
                      : SizedBox.square(
                          dimension: 40,
                          child: CircularProgressIndicator(
                            value: _hold.value,
                            strokeWidth: 3,
                            color: AppColors.primary,
                          ),
                        ),
                ),
                const Icon(
                  Icons.settings_rounded,
                  color: AppColors.inkSoft,
                  size: 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
