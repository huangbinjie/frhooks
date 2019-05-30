part of './hook.dart';

class _HookTypeError extends Error {}

class HookElement extends StatelessElement {
  Hook hook = Hook();
  int prevHooksLength = 0;
  int currentHooksLength = 0;
  bool _built = false;

  List<void Function() Function()> updatePhaseEffectQueue = [];
  List<void Function()> unmountPhaseEffectQueue = [];

  HookElement(HookWidget widget) : super(widget);

  Widget resetHooksAndReBuild() {
    hook = Hook();
    _built = false;
    prevHooksLength = 0;
    currentHooksLength = 0;
    _workInProgressHook = null;
    updatePhaseEffectQueue.clear();
    unmountPhaseEffectQueue.forEach((callback) => callback());
    unmountPhaseEffectQueue.clear();

    debugPrint(
        "Seems you have inserted/removed a hook, hooks will rerun the build(BuildContext context) of ${widget}");

    return build();
  }

  @override
  Widget build() {
    willBuild();
    Widget child;
    try {
      child = super.build();
    } catch (e) {
      if (e is _HookTypeError) {
        return resetHooksAndReBuild();
      } else {
        throw e;
      }
    }

    /// Type is correct, but length changed(append hook to last);
    if (_built == false || currentHooksLength == prevHooksLength) {
      didBuild();
    } else {
      return resetHooksAndReBuild();
    }
    return child;
  }

  void willBuild() {
    _stashedContextStack.add(this);
    currentHooksLength = 0;
  }

  /// cause of [mount] called before [build]. So create a method [didBuild] for react like didUpdate.
  void didBuild() {
    updatePhaseEffectQueue.forEach((callback) {
      var removalEffectCallback = callback();
      if (removalEffectCallback != null) {
        unmountPhaseEffectQueue.add(removalEffectCallback);
      }
    });

    updatePhaseEffectQueue.clear();
    _workInProgressHook = null;
    prevHooksLength = currentHooksLength;
    _built = true;
  }

  @override
  void unmount() {
    unmountPhaseEffectQueue.forEach((callback) => callback());
    unmountPhaseEffectQueue.clear();
    super.unmount();
  }

  @override
  void update(HookWidget newWidget) {
    super.update(newWidget);
  }
}
