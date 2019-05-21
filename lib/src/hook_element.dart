part of './hook.dart';

class HookElement extends StatelessElement {
  Hook hook = Hook();
  int prevHooksLength = 0;
  int currentHooksLength = 0;

  List<void Function() Function()> updatePhaseEffectQueue = [];
  List<void Function()> unmountPhaseEffectQueue = [];

  HookElement(HookWidget widget) : super(widget);

  void resetHooks() {
    hook = Hook();
    updatePhaseEffectQueue.clear();
    unmountPhaseEffectQueue.forEach((callback) => callback());
    unmountPhaseEffectQueue.clear();
  }

  @override
  Widget build() {
    willBuild();
    final child = super.build();
    if (prevHooksLength == 0 || currentHooksLength == prevHooksLength) {
      didBuild();
    } else {
      debugPrint(
          "Seems you have inserted/removed a hook, hooks will rerun the build of your widget ${widget}");
      resetHooks();
      return build();
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
