part of './hook.dart';

class HookElement extends StatelessElement {
  Hook hook = Hook();

  List<void Function() Function()> updatePhaseEffectQueue = [];
  List<void Function()> unmountPhaseEffectQueue = [];

  HookElement(HookWidget widget) : super(widget);

  @override
  Widget build() {
    willBuild();
    final child = super.build();
    didBuild();
    return child;
  }

  void willBuild() {
    _stashedContextStack.add(this);
  }

  /// cause of [mount] called before [build]. So create a method [didBuild] for react like didUpdate.
  void didBuild() {
    updatePhaseEffectQueue.forEach((callback) {
      var removalEffectCallback = callback();
      if (removalEffectCallback != null) {
        this.unmountPhaseEffectQueue.add(removalEffectCallback);
      }
    });

    updatePhaseEffectQueue.clear();
    _workInProgressHook = null;
  }

  @override
  void unmount() {
    this.unmountPhaseEffectQueue.forEach((callback) => callback());
    this.unmountPhaseEffectQueue.clear();
    super.unmount();
  }

  @override
  void update(HookWidget newWidget) {
    super.update(newWidget);
  }
}
