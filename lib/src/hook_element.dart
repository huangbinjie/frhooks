part of './hook.dart';

class _HookTypeError extends Error {}

class HookElement extends StatelessElement {
  Hook hook = Hook();
  int prevHooksLength = 0;
  int currentHooksLength = 0;

  List<void Function() Function()> updatePhaseEffectQueue = [];
  List<void Function()> unmountPhaseEffectQueue = [];

  HookElement(HookWidget widget) : super(widget);

  Widget resetHooksAndReBuild() {
    hook = Hook();
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

  /// Called after every relayout.
  void _postFrameCallback(_) {
    didBuild();
    WidgetsBinding.instance.addPostFrameCallback(_postFrameCallback);
  }

  @override
  void unmount() {
    unmountPhaseEffectQueue.forEach((callback) => callback());
    unmountPhaseEffectQueue.clear();
    super.unmount();
  }

  @override
  void mount(parent, newSlot) {
    WidgetsBinding.instance.addPostFrameCallback(_postFrameCallback);
    super.mount(parent, newSlot);
  }

  @override
  void update(HookWidget newWidget) {
    super.update(newWidget);
  }
}
