import 'package:flutter/material.dart';
import 'package:frhooks/frhooks.dart';

// copy from flutter_hooks
class HookBuilder extends HookWidget {
  /// The callback used by [HookBuilder] to create a widget.
  ///
  /// If a [Hook] asks for a rebuild, [builder] will be called again.
  /// [builder] must not return `null`.
  final Widget Function() builder;

  /// Creates a widget that delegates its build to a callback.
  ///
  /// The [builder] argument must not be null.
  const HookBuilder({
    required this.builder,
    super.key,
  });

  @override
  Widget build(context) => builder();
}
