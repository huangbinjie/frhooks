part of './hook.dart';

class _HookTypeError extends Error {}

class HookElement extends StatelessElement {
  Hook hook = Hook();

  // List<void Function() Function() | Future<void Function() Function()>
  List<dynamic Function()> effectQueue = [];

  List<void Function()> effectCleanupQueue = [];

  HookElement(HookWidget widget) : super(widget);

  Widget resetHooksAndReBuild() {
    hook = Hook();
    _workInProgressHook = null;
    effectCleanupQueue.forEach((cleanup) => cleanup());
    effectCleanupQueue.clear();
    effectQueue.clear();

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
    _stashedContext = this;
    _workInProgressHook = null;
    WidgetsBinding.instance.addPostFrameCallback(didBuild);
  }

  /// cause of [mount] called before [build]. So create a method [didBuild] for react like didUpdate.
  void didBuild(Duration duration) {
    effectCleanupQueue.forEach((cleanup) => cleanup());
    effectCleanupQueue.clear();

    effectQueue.forEach((create) {
      var cleanup = create();
      if (cleanup != null) {
        if (cleanup is Future) {
          cleanup.then((cb) {
            if (cb != null) {
              effectCleanupQueue.add(cb);
            }
          });
        } else {
          effectCleanupQueue.add(cleanup);
        }
      }
    });

    effectQueue.clear();
  }

  @override
  void unmount() {
    _stashedContext = null;
    _workInProgressHook = null;
    effectCleanupQueue.forEach((cleanup) => cleanup());
    effectCleanupQueue.clear();
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
