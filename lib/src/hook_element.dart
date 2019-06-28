part of './hook.dart';

class _HookTypeError extends Error {}

class HookElement extends StatelessElement {
  Hook hook = Hook();

  // List<void Function() Function() | Future<void Function() Function()>
  List<dynamic Function()> updatePhaseEffectQueue = [];

  List<void Function()> unmountPhaseEffectQueue = [];

  HookElement(HookWidget widget) : super(widget);

  Widget resetHooksAndReBuild() {
    hook = Hook();
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
    try {
      return super.build();
    } catch (e) {
      if (e is _HookTypeError) {
        return resetHooksAndReBuild();
      } else {
        throw e;
      }
    }
  }

  void willBuild() {
    _stashedContextStack.add(this);
    _workInProgressHook = null;
    WidgetsBinding.instance.addPostFrameCallback(didBuild);
  }

  /// cause of [mount] called before [build]. So create a method [didBuild] for react like didUpdate.
  void didBuild(Duration duration) {
    updatePhaseEffectQueue.forEach((callback) {
      var removeEffectCallback = callback();
      if (removeEffectCallback != null) {
        if (removeEffectCallback is Future) {
          removeEffectCallback.then((cb) {
            if (cb != null) {
              unmountPhaseEffectQueue.add(cb);
            }
          });
        } else {
          unmountPhaseEffectQueue.add(removeEffectCallback);
        }
      }
    });

    updatePhaseEffectQueue.clear();
  }

  @override
  void unmount() {
    _workInProgressHook = null;
    unmountPhaseEffectQueue.forEach((callback) => callback());
    unmountPhaseEffectQueue.clear();
    super.unmount();
  }

  @override
  void mount(parent, newSlot) {
    super.mount(parent, newSlot);
  }

  @override
  void update(HookWidget newWidget) {
    super.update(newWidget);
  }
}
